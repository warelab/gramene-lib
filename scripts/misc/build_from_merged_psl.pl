#!/usr/bin/perl -w
use strict;
use lib (".");
use MyIntSpan;
use UnionFind;

# nodes refer to contigs.  They can come from the reference AGP (non-Ns) or from the 454 assembly.
# some contigs can be flipped by cDNA evidence if they are not part of the reference or tied
# to it by a cDNA alignment.
#
# The AGP defines a single path through the BAC contigs. (gaps of different types exist)
# edges in the graph are of various classes
#   within the AGP, edges can only tolerate insertions
#   the qty of DNA that can be inserted depends on the type of gap in the AGP
#   edges between an assembled chr and a 454 contig
#   between assembled chr and chr0???
#   between 454-contig and chr0
#   between 454 contigs.
#
# read the AGP in as a directed graph with N's between nodes
#
# read psl hits in and add to the AGP based graph where possible, otherwise build 454-only scaffolds

# the gap type hash says how much DNA can be inserted into a gap in the AGP
# this is not used in the code...
my %gap_type = (
    fragment => 100000,
    clone_n  => 500000,
    clone_y  => 1000000
);

# this edge_class isn't used either
my %edge_class = (
    abyss2abyss => [],
    agp2abyss   => [],
    agp2chr0    => []
);

my $AGP_gzfile       = shift @ARGV;
my $scaffold_file    = shift @ARGV;
my $outdir           = shift @ARGV;
my $do_graphs        = shift @ARGV;
my $contig_GBS       = shift @ARGV;
my $cDNA_GBS         = shift @ARGV;
my $synteny_map_file = shift @ARGV;

my %gpos;          # hash for holding the genetic position for contigs and cDNAs
my %synteny_map;   # hash for holding the syntenic position(s) of contigs
my %bridges;       # hash for holding the gaps that cDNAs probably jump into

my ( $agp, $offsets, $nodes, $edges, $uf ) = read_AGP($AGP_gzfile);
read_gpos($contig_GBS);
read_gpos($cDNA_GBS);
read_synteny_map($synteny_map_file);
build_scaffolds($scaffold_file);

place_scaffolds( \%gpos, \%synteny_map, \%bridges );

if ($do_graphs) {
    output_graph();
}
output_agp();

exit;

sub read_AGP {
    my $in = shift;
    my ( %nonNs, %gaps );
    open( IN, "gzip -cd $in |" ) or die "failed to open $in\n";
    while (<IN>) {
        chomp;
        my ( $chr, $from, $to, $i, $DN, @etc ) = split /\t/, $_;
        $chr = "chr$chr";
        if ( $DN eq 'N' ) {
            my $gap_type = $etc[1];
            if ( $gap_type eq 'clone' ) {
                $gap_type .= ( $etc[2] eq 'yes' ) ? "_y" : "_n";
            }
            push @{ $gaps{$chr} }, $gap_type;
        }
        elsif ( $DN eq 'D' ) {
            if ( $nonNs{$chr} and $nonNs{$chr}[-1][-1] + 1 == $from ) {
                $nonNs{$chr}[-1][-1] = $to;
            }
            else {
                push @{ $nonNs{$chr} }, [ $from, $to ];
            }
        }
    }
    close IN;

# create MyIntSpan objects for each chromosome
# so we can get node id's from hits. using $node_id = $agp{$chr}->span_ord($hitpos) + $offset{$chr};

    my ( %agp,   %offset );
    my ( @nodes, %edges );
    my $uf = new UnionFind;
    for my $chr ( keys %nonNs ) {
        $agp{$chr} = new MyIntSpan $nonNs{$chr};
        print STDERR "created MyIntSpan for $chr\n";
        $offset{$chr} = scalar @nodes;
        for ( my $i = 0 ; $i < @{ $nonNs{$chr} } ; $i++ ) {
            my $n = @nodes;
            $uf->MakeSet( $n, [ $chr, @{ $nonNs{$chr}[$i] } ] )
              ;    # see also the Check subroutine in UnionFind.pm
            push @nodes, [ 'agp', $chr, 1, 0, @{ $nonNs{$chr}[$i] }, [] ];

            # [class,seq,strand,flippable,from,to,[RNA]]
            next; # because we don't need the AGP graph and connected components
            if ( $i > 0 ) {
                $uf->Union( $n - 1, $n );
                $edges->{ $n - 1 }{$n} =
                  [ 'AGP', $gap_type{ $gaps{$chr}[ $i - 1 ] }, 1000 ]
                  ;    # class,space remaining, support
            }
        }
    }

    # add nodes for the organelles (not changing these, just needed for code)
    $offset{chloroplast} = scalar @nodes;
    $agp{chloroplast} = new MyIntSpan [ [ 1, 569630 ] ];
    push @nodes, [ 'agp', 'chloroplast', 1, 0, 1, 569630, [] ];
    $uf->MakeSet( $#nodes, [ 'chloroplast', 1, 569360 ] );

    $offset{mitochondrion} = scalar @nodes;
    $agp{mitochondrion} = new MyIntSpan [ [ 1, 140384 ] ];
    push @nodes, [ 'agp', 'mitochondrion', 1, 0, 1, 140384, [] ];
    $uf->MakeSet( $#nodes, [ 'mitochondrion', 1, 140384 ] );

    return ( \%agp, \%offset, \@nodes, \%edges, $uf );
}

sub read_gpos {
    my $infile = shift;
    open( IN, "<", $infile ) or die "failed to open $infile for reading:$!\n";
    while (<IN>) {
        chomp;
        /^[0-9]/ or next;
        my ( $seqid, $chr, $start, $end, $mean ) = split /\t/, $_;
        exists $gpos{$seqid}
          and die "$seqid already exists in gpos hash! reading from $infile\n";
        $gpos{$seqid} = [ "chr" . $chr, $start, $end ];
    }
    close IN;
}

sub read_synteny_map {
    my $infile = shift;
    open( IN, "<", $infile ) or die "failed to open $infile for reading:$!\n";
    while (<IN>) {
        chomp;
        my ( $seqid, $syn_gene, $subgenome, $chr, $from, $to, $method ) =
          split /\t/, $_;
        $method = "non-direct" if $method ne "direct";
        $synteny_map{$seqid}{$chr} = [ $from, $to, $method ];
    }
    close IN;
}

sub build_scaffolds {
    my $scaffold_file = shift;

    my @PSL = qw( match mismatch rep_match Ns
      q_gap_count q_gap_bases t_gap_count t_gap_bases
      strand q_name q_size q_start q_end
      t_name t_size t_start t_end
      block_count blockSizes qStarts tStarts );

    open( IN, "<", $scaffold_file )
      or die "failed to open $scaffold_file: $!\n";
    my @scaffold;
    while (<IN>) {
        chomp;

        # read this hit
        my @c = split /\t/, $_;
        my %hit;
        for ( my $i = 0 ; $i < @c ; $i++ ) {
            $hit{ $PSL[$i] } = $c[$i];
        }
        $hit{t_start}++;
        $hit{q_start}++;
        $hit{strand} = $hit{strand} eq '+' ? 1 : -1;
        if ( @scaffold and $scaffold[-1]{q_name} eq $hit{q_name} ) {
            push @scaffold, \%hit;
        }
        else {
            if (@scaffold) {

                # add this as a hyperedge to the graph.
                add_scaffold_to_graph( \@scaffold, 0 );
            }
            @scaffold = ( \%hit );
        }
    }
    close IN;
    if (@scaffold) {

        # add this scaffold as a hyperedge to the graph
        add_scaffold_to_graph( \@scaffold, 0 );
    }
}

# this is the key subroutine.  A set of hits to reference and/or de-novo
# contigs are passed in.  This set is ordered and oriented based on
# the cDNA.  If any of the contigs have already been seen the new ones
# are flipped if necessary and added to the graph.
#
# consistancy with genetic map and/or syntenic position is preserved
sub add_scaffold_to_graph {
    my $hitsref   = shift;
    my $recursion = shift;
    my $rna_name  = $hitsref->[0]{q_name};
    print STDERR "add_scaffold_to_graph($rna_name,$recursion)\n";

    # check if any of the his are to an agp chromosome
    my $oriented = 0;
    for my $hit (@$hitsref) {
        if ( $hit->{t_name} !~ m/^\d+$/ ) {
            $oriented = $hit->{strand};
            last;
        }
    }

    # flip the hits if necessary
    if ($oriented) {
        $hitsref = flip($hitsref) if ( $oriented == -1 );
        $oriented = 1;
    }

    # add new nodes to the graph
    for my $hit (@$hitsref) {
        my $ctg     = $hit->{t_name};
        my $rna_hit = $rna_name . "\t" . $hit->{q_start} . "\t" . $hit->{q_end};
        if ( not exists $offsets->{$ctg} ) {
            $offsets->{$ctg} = @$nodes;
            $agp->{$ctg} = new MyIntSpan [ [ 1, $hit->{t_size} ] ];
            $uf->MakeSet( $offsets->{$ctg}, choose_gpos( $ctg, $rna_name ) )
              ;    ## choose_gpos is strict
            push @$nodes,
              [
                'abyss',        $ctg,
                $hit->{strand}, $oriented,
                !$oriented,     $hit->{t_size},
                [$rna_name]
              ];

            # the flippable bit is not used.
        }
        else {

            # append $rna_name to the list of seqs in this node?
            my $node_idx =
              $offsets->{$ctg} + $agp->{$ctg}->span_ord( $hit->{t_start} );
            push @{ $nodes->[$node_idx][6] }, $rna_name;
        }
    }

    # connect the nodes
    # check for inconsistancies, flip or break as needed
    for ( my $i = 1 ; $i < @$hitsref ; $i++ ) {

        # try to add edge from i-1 to i
        my $p_hit = $hitsref->[ $i - 1 ];
        my $p_ctg = $p_hit->{t_name};
        my $p_node =
          $offsets->{$p_ctg} + $agp->{$p_ctg}->span_ord( $p_hit->{t_end} );
        my $c_hit = $hitsref->[$i];
        my $c_ctg = $c_hit->{t_name};
        my $c_node =
          $offsets->{$c_ctg} + $agp->{$c_ctg}->span_ord( $c_hit->{t_start} );

        my $p_span =
          $agp->{$p_ctg}
          ->span_index( $agp->{$p_ctg}->span_ord( $p_hit->{t_end} ) );
        my $c_span =
          $agp->{$c_ctg}
          ->span_index( $agp->{$c_ctg}->span_ord( $c_hit->{t_start} ) );
        print STDERR
"considering edge from $p_ctg [$$p_span[0], $$p_span[1]] to $c_ctg [$$c_span[0], $$c_span[1]]\n";

        # skip to the next hit if it's to the same ctg/chr
        if ( $p_ctg eq $c_ctg ) {
            print STDERR "#### 1 skipping:: same contig\n";
            next;
        }

        # check if this edge bridges connected components that
        # are oriented (anchored to a chromosome)
        if ( not $uf->Compatible( $p_node, $c_node ) ) {
            print STDERR "#### 2 skipping:: bridges incompatible contigs ",
              $uf->AGP_range($p_node), " ", $uf->AGP_range($c_node), "\n";
            next;
        }

        # add a check to see if this edge would mess up the DAG
        # instead of a full check, just skip it if both nodes are in the
        # same cc
        if ( $recursion and $uf->Find($p_node) == $uf->Find($c_node) ) {
            print STDERR "#### 3 skipping:: same connected component\n";
            next;
        }

        # check if the orientation is as expected
        if ( $c_hit->{strand} == $nodes->[$c_node][2] ) {

            # added an edge from $p_node to $c_node
            add_edge( $p_node, $c_node, $rna_name );
        }
        else {

            # try flipping $c_node's connected component
            if ( flip_subgraph($c_node) ) {
                print STDERR "#### 4 flipped c_node $c_node\n";
                add_edge( $p_node, $c_node, $rna_name );
            }
            else {

                # couldn't flip the subgraph try $p_node's cc
                if ( $recursion != 1 and flip_subgraph($p_node) ) {
                    print STDERR "#### 5 flipped p_node $p_node\n";
                    return add_scaffold_to_graph( flip($hitsref), 1 );
                }
                else {

                    # couldn't flip that way either...
                    print STDERR "#### 6 need to break $$hitsref[0]{q_name}\n";
                    my @remaining_hits = splice( @$hitsref, $i );
                    return add_scaffold_to_graph( \@remaining_hits, 0 );
                }
            }
        }
    }
}

sub flip_subgraph {
    my $node_id = shift;

    $uf->Check($node_id) and return 0;

    # get the connected component of $node_id
    my $cc = $uf->Neighbors($node_id);

    # flip each node in the cc and any edges between them and return 1
    my @edges2flip;
    for my $id (@$cc) {
        $nodes->[$id][2] *= -1;
        for my $to ( keys %{ $edges->{$id} } ) {
            push @edges2flip, [ $id, $to ];
        }
    }
    for my $edge (@edges2flip) {
        my ( $from, $to ) = @$edge;
        if ( exists $edges->{$to}{$from} ) {
            my $tmp = $edges->{$to}{$from};
            $edges->{$to}{$from} = $edges->{$from}{$to};
            $edges->{$from}{$to} = $tmp;
        }
        else {
            $edges->{$to}{$from} = $edges->{$from}{$to};
            delete $edges->{$from}{$to};
        }
    }
    return 1;
}

sub add_edge {
    my ( $from, $to, $seq ) = @_;
    print STDERR "add_edge( $from, $to, $seq )\n";

    # class,space remaining, support
    if ( exists $edges->{$from}{$to} ) {

        # this edge is already there, increment support
        $edges->{$from}{$to}[2]++;

        push @{ $edges->{$from}{$to}[3] }, $seq;
    }
    else {

        # need to create an edge
        $edges->{$from}{$to} = [ 'a2b', 1, 1, [$seq] ];
        if ( exists $edges->{$to}{$from} ) {
            print STDERR
              "this edge already exists - in the other direction!!\n";
            print STDERR "from: ", join( ", ", @{ $nodes->[$from] } ), "\n";
            print STDERR "  to: ", join( ", ", @{ $nodes->[$to] } ),   "\n";
        }
        else {
            $uf->Union( $from, $to );

            # check if this edge connects the reference to a de-novo contig
            my ( $chr, $gap_from, $gap_to, $abyss );
            if ( $nodes->[$from][0] eq 'agp' ) {
                $chr = $nodes->[$from][1];
                if ( $nodes->[$to][0] eq 'abyss' ) {
                    $abyss = $nodes->[$to][1];
                    if ( $nodes->[$from][2] == 1 )
                    {    # alignment to chr is +, so abyss follows node
                        $gap_from = $nodes->[$from][5] + 1;
                        $gap_to   = $nodes->[ $from + 1 ][4] - 1;
                    }
                    else {    # gap preceeds node
                        $gap_from = $nodes->[ $from - 1 ][5] + 1;
                        $gap_to   = $nodes->[$from][4] - 1;
                    }
                }
            }
            elsif ( $nodes->[$to][0] eq 'agp' ) {
                $abyss = $nodes->[$from][1];
                $chr   = $nodes->[$to][1];
                if ( $nodes->[$to][2] == -1 ) {    # gap follows node
                    $gap_from = $nodes->[$to][5] + 1;
                    $gap_to   = $nodes->[ $to + 1 ][4] - 1;
                }
                else {                             # gap preceeds node
                    $gap_from = $nodes->[ $to - 1 ][5] + 1;
                    $gap_to   = $nodes->[$to][4] - 1;
                }
            }

            # don't bridge before or after the chromosome.
            if ( $chr and $gap_from < $gap_to ) {
                $bridges{$seq}{$abyss} = [ $chr, $gap_from, $gap_to ];
            }
        }
    }
}

sub flip {
    my $hitsref = shift;
    my @flipped;
    for my $hit (@$hitsref) {
        $hit->{strand} *= -1;
        unshift @flipped, $hit;
    }
    return \@flipped;
}

# given a contig and the cDNA that picked it, lookup possible locations on the reference.
# choose the most specific position range available.  in the event of a conflict
# don't assign a position.
sub choose_gpos {
    my ( $contig, $cDNA ) = @_;
    my @contig_gbs = exists $gpos{$contig} ? @{ $gpos{$contig} } : ();
    my @cDNA_gbs   = exists $gpos{$cDNA}   ? @{ $gpos{$cDNA} }   : ();

    my @range = intersect_ranges( \@contig_gbs, \@cDNA_gbs );

    if (@range) {
        my @fatrange = @range;
        $fatrange[1] -= 1000000;
        $fatrange[2] += 1000000;

        # try to refine genetic range with synteny
        my @contig_syn = ();
        if ( exists $synteny_map{$contig}
            and $synteny_map{$contig}{ $range[0] } )
        {

            # contig has synteny to same chromosome
            @contig_syn =
              ( $range[0], @{ $synteny_map{$contig}{ $range[0] } } );
            print STDERR
              join( "\t", "#mapped contig#", $contig, $cDNA, @contig_syn ), "\n"
              if ( intersect_ranges( \@fatrange, \@contig_syn ) );
        }
        my @cDNA_syn = ();
        if ( exists $synteny_map{$cDNA} and $synteny_map{$cDNA}{ $range[0] } ) {

            # cDNA has synteny to same chromosome
            @cDNA_syn = ( $range[0], @{ $synteny_map{$cDNA}{ $range[0] } } );
            print STDERR
              join( "\t", "#mapped cDNA#", $contig, $cDNA, @cDNA_syn ), "\n"
              if ( intersect_ranges( \@fatrange, \@cDNA_syn ) );
        }
        my @syn   = intersect_ranges( \@contig_syn, \@cDNA_syn );
        my @agree = intersect_ranges( \@range,      \@syn );
        @agree and return \@agree;
        @agree = intersect_ranges( \@range, \@contig_syn ) if @contig_syn;
        @agree and return \@agree;
        @agree = intersect_ranges( \@range, \@cDNA_syn ) if @cDNA_syn;
        @agree and return \@agree;
        return \@range;
    }
    else {
        my @contig_syn = ();
        if ( exists $synteny_map{$contig} ) {
            for my $chr ( keys %{ $synteny_map{$contig} } ) {
                @contig_syn = ( $chr, @{ $synteny_map{$contig}{$chr} } );
                print STDERR
                  join( "\t", "#unmapped contig#", $contig, $cDNA,
                    @contig_syn ), "\n";
            }
        }
        my @cDNA_syn = ();
        if ( exists $synteny_map{$cDNA} ) {
            for my $chr ( keys %{ $synteny_map{$cDNA} } ) {
                @cDNA_syn = ( $chr, @{ $synteny_map{$cDNA}{$chr} } );
                print STDERR
                  join( "\t", "#unmapped cDNA#", $contig, $cDNA, @cDNA_syn ),
                  "\n";
            }
        }
        return [];    ### don't let synteny alone place contigs
        ### unless there is a missing ortholog?

        # assign a range if only one syntenic position exists
        @cDNA_syn = ();
        if ( exists $synteny_map{$cDNA} ) {
            my @k = keys %{ $synteny_map{$cDNA} };
            if ( @k == 1 ) {
                @cDNA_syn = (
                    $k[0],
                    $synteny_map{$cDNA}{ $k[0] }[0],
                    $synteny_map{$cDNA}{ $k[0] }[1]
                );
            }
        }
        @contig_syn = ();
        if ( exists $synteny_map{$contig} ) {
            my @k = keys %{ $synteny_map{$contig} };
            if ( @k == 1 ) {
                @contig_syn = (
                    $k[0],
                    $synteny_map{$contig}{ $k[0] }[0],
                    $synteny_map{$contig}{ $k[0] }[1]
                );
            }
        }
        @range = intersect_ranges( \@contig_syn, \@cDNA_syn );
        @range      and return \@range;
        @cDNA_syn   and return \@cDNA_syn;
        @contig_syn and return \@contig_syn;
        return [];
    }
}

# if either argument is empty, return the other one
sub intersect_ranges {
    my ( $r1, $r2 ) = @_;
    @$r1 or return @$r2;
    @$r2 or return @$r1;
    if ( $r1->[0] ne $r2->[0] ) {    # different chromosomes
        return ();
    }
    if ( $r1->[2] >= $r2->[1] and $r1->[1] <= $r2->[2] ) {   # intervals overlap
        my @x = sort { $a <=> $b } ( $r1->[1], $r1->[2], $r2->[1], $r2->[2] );
        return ( $r1->[0], $x[1], $x[2] );
    }
    return ();
}

sub place_scaffolds {
    my ( $gpos, $syn, $bridge ) = @_;
    my $leeway   = 1000000;
    my $scaffold = 0;
    for my $root ( keys %{ $uf->{is_root} } ) {

        # skip the ones that are skipped in output_agp
        my $size = scalar @{ $uf->{neighbors}{$root} };
        next if ( $size == 1 and $nodes->[$root][0] eq 'agp' );

        $scaffold++;
        print STDERR "place_scaffolds:: before : ", $uf->AGP_range($root), "\n";
        $uf->{agp_range}{$root} = [];    # reset the range
                                         # gather the contigs and cDNAs
        my %contigs;
        my %cDNAs;
        for my $node ( @{ $uf->{neighbors}{$root} } ) {
            $contigs{ $nodes->[$node][1] } = 1;
            for my $rna ( @{ $nodes->[$node][6] } ) {
                $cDNAs{$rna} = 1;
            }
        }

#1) Map position can only be called for those scaffolds having GBS or Bridge.
#2) No synteny data is required for calling confirming map position
#3) Where GBS and Bridge disagree entirely (threshold tbd) SYN can be used as a tie-breaker; otherwise GBS is to be trusted.
#4) Where GBS and Bridge agree, Bridge should be used to define position as it will be more precise.
#5) Synteny data is used for tie-breaking between Bridge/GBS, GBS/GBS, or Bridge/Bridge.
#6) Synteny data cannot be used in the absence of Bridge or GBS (even when no ambiguity with multiple SYN?  Can we use (missing) ortholog data to refine?).
#7) Synteny data used to refine position.  Increase leeway for definition of agreement.  10Kb to strict for example contig 2748:
        my ( @GBS_intervals, @syn_GBS_intervals );
        my ( @bridge_gaps,   @syn_bridge_gaps );
        my @seqs2check;
        push @seqs2check, keys %contigs if %contigs;
        push @seqs2check, keys %cDNAs   if %cDNAs;
        for my $seq (@seqs2check) {
            if ( $gpos->{$seq} ) {
                my ( $chr, $from, $to ) = @{ $gpos->{$seq} };
                my $syn_support = 0;
                if ( $syn->{$seq}{$chr} ) {
                    my $syn_from = $syn->{$seq}{$chr}[0] - $leeway;
                    my $syn_to   = $syn->{$seq}{$chr}[1] + $leeway;
                    if ( $syn_from <= $to and $syn_to >= $from ) {
                        $syn_support = 1;
                        print STDERR
                          "GBS $seq has syn_support $chr $from $to\n";
                    }
                }
                push @GBS_intervals, [ $chr, $from, $to ];
                push @syn_GBS_intervals, [ $chr, $from, $to ] if $syn_support;
            }
            if ( $bridge->{$seq} ) {
                for my $contig ( keys %{ $bridge->{$seq} } ) {
                    if ( $contigs{$contig} ) {
                        my ( $chr, $from, $to ) = @{ $bridge->{$seq}{$contig} };
                        my $syn_support = 0;
                        if ( $syn->{$seq}{$chr} ) {
                            my $syn_from = $syn->{$seq}{$chr}[0] - $leeway;
                            my $syn_to   = $syn->{$seq}{$chr}[1] + $leeway;
                            if ( $syn_from <= $to and $syn_to >= $from ) {
                                $syn_support = 1;
                            }
                        }
                        push @bridge_gaps, [ $chr, $from, $to ];
                        if ($syn_support) {
                            print STDERR
"bridge $seq -> $contig cDNA has syn_support $chr $from $to\n";
                            push @syn_bridge_gaps, [ $chr, $from, $to ];
                        }
                        elsif ( $syn->{$contig}{$chr} ) {
                            my $syn_from = $syn->{$contig}{$chr}[0] - $leeway;
                            my $syn_to   = $syn->{$contig}{$chr}[1] + $leeway;
                            if ( $syn_from <= $to and $syn_to >= $from ) {
                                print STDERR
"bridge $seq -> $contig contig has syn_support $chr $from $to\n";
                                push @syn_bridge_gaps, [ $chr, $from, $to ];
                            }
                        }
                    }
                }
            }
        }
        @GBS_intervals or @bridge_gaps or next;

        # prioritize intervals that have syntenic support
        my $GBS_clusters =
          @syn_GBS_intervals
          ? top_clusters( cluster_votes( \@syn_GBS_intervals ) )
          : top_clusters( cluster_votes( \@GBS_intervals ) );
        my $bridge_clusters =
          @syn_bridge_gaps
          ? top_clusters( cluster_votes( \@syn_bridge_gaps ) )
          : top_clusters( cluster_votes( \@bridge_gaps ) );

        my $n_GBS     = @$GBS_clusters;
        my $n_bridges = @$bridge_clusters;

        # update the scaffold position.
        if ( $n_GBS + $n_bridges > 1 ) {
            print STDERR join( "\t", "TABLE", $scaffold, $n_GBS, $n_bridges ),
              "\n";
            for my $interval (@$GBS_clusters) {
                print STDERR join( "\t", "GBS", @$interval ), "\n";
            }
            for my $interval (@$bridge_clusters) {
                print STDERR join( "\t", "bridge", @$interval ), "\n";
            }
        }
        my $method = 0;
        if ($n_bridges) {
            if ($n_GBS) {

                # check for a pair that agrees
                # if there is no such pair, merge the top GBS_clusters
                my @agree;
                for my $b_int (@$bridge_clusters) {
                    for my $g_int (@$GBS_clusters) {
                        if (    $b_int->[0] eq $g_int->[0]
                            and $b_int->[1] < $g_int->[2] + $leeway
                            and $b_int->[2] > $g_int->[1] - $leeway )
                        {
                            push @agree, $b_int;
                        }
                    }
                }
                if (@agree) {
                    $method = 1;
                    $uf->{agp_range}{$root} = spanner( \@agree );
                }
                else {
                    $method = 2;
                    $uf->{agp_range}{$root} = spanner($GBS_clusters);
                }
            }
            else {

                # only bridges
                $method = 3;
                $uf->{agp_range}{$root} = spanner($bridge_clusters);
            }
        }
        else {

            # no bridges
            if ($n_GBS) {
                $method = 4;
                $uf->{agp_range}{$root} = spanner($GBS_clusters);
            }
        }

        print STDERR "place_scaffolds:: after : $method : ",
          $uf->AGP_range($root), "\n";
    }
}

sub spanner {
    my $intervals = shift;
    my @sorted    = sort { $b->[3] <=> $a->[3] } @$intervals;
    my $interval  = shift @sorted;
    my @span      = @$interval;
    for $interval (@sorted) {
        my ( $chr, $from, $to, $score ) = @$interval;
        last if ( $score < $span[3] );
        $chr eq $span[0]
          or die
"span() didn't expect to see conflicts on the chromosome level $chr ne $span[0]\n";
        $span[1] = $from if $from < $span[1];
        $span[2] = $to   if $to > $span[2];
    }
    $span[1]++;
    return \@span;
}

sub top_clusters {
    my $clusters = shift;
    my @tops;
    for my $cluster (@$clusters) {
        my ( $intervals, $max_depth ) = @$cluster;
        my ( $chr, $min, $max ) =
          ( $intervals->[0][0], $intervals->[-1][2], $intervals->[0][1] );
        for my $interval (@$intervals) {
            if ( $interval->[3] == $max_depth ) {
                $min = $interval->[1] if $interval->[1] < $min;
                $max = $interval->[2] if $interval->[2] > $max;
            }
        }
        push @tops, [ $chr, $min, $max, $max_depth ];
    }
    return \@tops;
}

# This subroutine iterates over the scaffolds that have already been assembled and
# tries to choose a location to map the scaffold to through an election.
sub place_scaffolds_score {
    my ( $gpos, $syn, $bridge ) = @_;
    print STDERR join( "\t",
        qw(TABLE scaffold n_contigs n_cDNAs GBS_contigs SYN_contigs GBS_cDNAs SYN_cDNAs bridges n_syn n_others n_merged n_winners e_type e_id e_class e_chr e_from e_to)
      ),
      "\n";

    # loop over the scaffolds
    my $scaffold = 0;
    for my $root ( keys %{ $uf->{is_root} } ) {

        # skip the ones that are skipped in output_agp
        my $size = scalar @{ $uf->{neighbors}{$root} };
        next if ( $size == 1 and $nodes->[$root][0] eq 'agp' );
        $scaffold++;

        # gather the contigs and cDNAs
        my @contigs;
        my %cDNAs;
        for my $node ( @{ $uf->{neighbors}{$root} } ) {
            push @contigs, $nodes->[$node][1];
            for my $rna ( @{ $nodes->[$node][6] } ) {
                $cDNAs{$rna} = 1;
            }
        }

# Hold an election and let each contig and cDNA vote for one or more positions
#
# 1. Each contig with a genetic mapping votes for the assigned range
# 2. Each contig with a syntenic mapping votes for each range (A and B subgenome)
#    syntentic votes are normalized so they don't trump the genetic mapping votes
# 3. Each cDNA with a genetic mapping votes for the assigned range
# 4. Each cDNA that aligns to the reference and a de-novo contig votes for the nearest gap
#
# results are tallied and the highest scoring subinterval is the winner

        # this is being implemented like a wiggle track (chr, from, to, score)
        # reusing some code from wigify to tally the votes
        my @votes;
        my @synvotes;
        my ( $g_count, $s_count ) = ( 0, 0 );
        my $n_contigs = @contigs;
        my %t2;
        for my $contig (@contigs) {
            if ( $gpos->{$contig} ) {
                $g_count++;
                $t2{contig}{$contig}{GBS} = [ $gpos->{$contig} ];
                push @votes, $gpos->{$contig};    # 1
                print STDERR
                  join( "\t", "gpos(contig $contig)", @{ $votes[-1] } ), "\n";
            }
            if ( $syn->{$contig} ) {
                $s_count++;
                for my $chr ( keys %{ $syn->{$contig} } ) {
                    push @synvotes,
                      [
                        $chr, $syn->{$contig}{$chr}[0],
                        $syn->{$contig}{$chr}[1]
                      ];                          # 2
                    push @{ $t2{contig}{$contig}{SYN} }, $synvotes[-1];
                    print STDERR
                      join( "\t", "syn(contig $contig)", @{ $synvotes[-1] } ),
                      "\n";
                }
            }
        }
        my ( $g_count2, $s_count2, $b_count ) = ( 0, 0, 0 );
        my $n_cDNAs = 0;
        for my $cDNA ( keys %cDNAs ) {
            $n_cDNAs++;
            if ( $gpos->{$cDNA} ) {
                $g_count2++;
                push @votes, $gpos->{$cDNA};    # 3
                $t2{cDNA}{$cDNA}{GBS} = [ $gpos->{$cDNA} ];
                print STDERR join( "\t", "gpos(cDNA $cDNA)", @{ $votes[-1] } ),
                  "\n";
            }
            if ( $syn->{$cDNA} ) {
                $s_count2++;
                for my $chr ( keys %{ $syn->{$cDNA} } ) {
                    push @synvotes,
                      [ $chr, $syn->{$cDNA}{$chr}[0], $syn->{$cDNA}{$chr}[1] ]
                      ;                         # 2
                    push @{ $t2{cDNA}{$cDNA}{SYN} }, $synvotes[-1];
                    print STDERR
                      join( "\t", "syn(cDNA $cDNA)", @{ $synvotes[-1] } ), "\n";
                }
            }
            if ( $bridge->{$cDNA} ) {
                my @gaps;
                for my $contig (@contigs) {
                    if ( exists $bridge->{$cDNA}{$contig} ) {
                        push @gaps, $bridge->{$cDNA}{$contig};
                    }
                }
                if (@gaps) {
                    $b_count++;
                    $t2{cDNA}{$cDNA}{bridge} = \@gaps;
                }
                for my $gap (@gaps) {
                    push @votes, $gap;    # 4
                    print STDERR
                      join( "\t", "bridge(cDNA $cDNA)", @{ $votes[-1] } ), "\n";
                }
            }
        }

        # normalize synvotes
        my $syn_clusters =
          merge_adjacents( ungroup( cluster_votes( \@synvotes ) ) );
        my $n_syn         = @$syn_clusters;
        my $max_syn_score = 0;
        for my $ilist (@$syn_clusters) {
            $max_syn_score = $ilist->[3] if ( $ilist->[3] > $max_syn_score );
        }
        my @normalized_syn;
        for my $ilist (@$syn_clusters) {
            my ( $chr, $st, $end, $score ) = @$ilist;
            push @{ $t2{cluster}{$score}{SYN} },
              [ $chr, $st, $end, $score / $max_syn_score ];
            push @normalized_syn, [ $chr, $st, $end, $score / $max_syn_score ];
        }

        my $other_clusters =
          merge_adjacents( ungroup( cluster_votes( \@votes ) ) );
        for my $ilist (@$other_clusters) {
            my ( $chr, $st, $end, $score ) = @$ilist;
            push @{ $t2{cluster}{aaa}{OTHER} }, [ $chr, $st, $end, $score ];
        }
        my $n_others = @$other_clusters;
        my $intervals =
          merge_adjacents(
            merge_clusters( \@normalized_syn, $other_clusters ) );
        my $n_merged = @$intervals;

        my $n_winners = 0;
        if (@$intervals) {

# rank the intervals by votes, length (shorter is better), and position (determanistic)
            my @sorted_intervals = sort {
                $b->[3] <=> $a->[3]
                  or $a->[2] - $a->[1] <=> $b->[2] - $b->[1]
                  or $a->[1] <=> $b->[1]
            } @$intervals;

            for my $interval (@$intervals) {
                print STDERR join( "\t", "interval", @$interval ), "\n";
            }

            my $winner = shift @sorted_intervals;
            $n_winners++;
            print STDERR "winner ::\t", join( "\t", @$winner ), "\n";
            $uf->{agp_range}{$root} =
              [ $winner->[0], $winner->[1], $winner->[2] ];
            $t2{scaffold}{$scaffold}{WINNER} = [$winner];

            while ( @sorted_intervals
                and $winner->[3] == $sorted_intervals[0][3] )
            {
                my $tie = shift @sorted_intervals;
                push @{ $t2{scaffold}{$scaffold}{WINNER} }, $tie;
                print STDERR "tie ::\t", join( "\t", @$tie ), "\n";
                $n_winners++;
            }
        }
        print STDERR "place_scaffolds:: after ", $uf->AGP_range($root), "\n";
        my @summary = (
            $scaffold, $n_contigs, $n_cDNAs,  $g_count,
            $s_count,  $g_count2,  $s_count2, $b_count,
            $n_syn,    $n_others,  $n_merged, $n_winners
        );
        for my $eclass ( keys %t2 ) {
            for my $seqid ( keys %{ $t2{$eclass} } ) {
                for my $etype ( keys %{ $t2{$eclass}{$seqid} } ) {
                    for my $range ( @{ $t2{$eclass}{$seqid}{$etype} } ) {
                        print STDERR join( "\t",
                            "TABLE", @summary, $eclass,
                            $seqid,  $etype,   @$range ),
                          "\n";
                    }
                }
            }
        }
    }
}

sub ungroup {
    my $superset = shift;
    my @ungrouped;
    for my $set (@$superset) {
        for my $ilist (@$set) {
            push @ungrouped, $ilist;
        }
    }
    return \@ungrouped;
}

sub merge_clusters {
    my ( $set1, $set2 ) = @_;
    if (@$set1) {
        if (@$set2) {

            # do the merge
            my @merged;
            my $wig1 = shift @$set1;
            my $wig2 = shift @$set2;
            my @copy;
            while ( $wig1 and $wig2 ) {
                if ( $wig1->[0] lt $wig2->[0] ) {
                    push @merged, $wig1;
                    $wig1 = shift @$set1;
                }
                elsif ( $wig1->[0] gt $wig2->[0] ) {
                    push @merged, $wig2;
                    $wig2 = shift @$set2;
                }
                else {    # same chr
                    if ( $wig1->[2] < $wig2->[1] ) {
                        push @merged, $wig1;
                        $wig1 = shift @$set1;
                    }
                    elsif ( $wig2->[2] < $wig1->[1] ) {
                        push @merged, $wig2;
                        $wig2 = shift @$set2;
                    }
                    else {    # wig1 and wig2 overlap or touch
                        if ( $wig1->[1] < $wig2->[1] ) {    # wig1 starts first
                            @copy = @$wig1;
                            $copy[2] = $wig2->[1];
                            push @merged, \@copy;
                            $wig1->[1] = $wig2->[1];
                        }
                        elsif ( $wig1->[1] > $wig2->[1] ) {  # wig2 starts first
                            @copy = @$wig2;
                            $copy[2] = $wig1->[1];
                            push @merged, \@copy;
                            $wig2->[1] = $wig1->[1];
                        }
                        else {                               # same starting pos
                            if ( $wig1->[2] < $wig2->[2] ) {
                                $wig1->[3] +=
                                  $wig2->[3];    # if ($wig2->[3] > $wig1->[3]);
                                push @merged, $wig1;
                                $wig2->[1] = $wig1->[2];
                                $wig1 = shift @$set1;
                            }
                            elsif ( $wig1->[2] > $wig2->[2] ) {
                                $wig2->[3] +=
                                  $wig1->[3];    # if ($wig2->[3] < $wig1->[3]);
                                push @merged, $wig2;
                                $wig1->[1] = $wig2->[2];
                                $wig2 = shift @$set2;
                            }
                            else {               # same ending pos
                                $wig1->[3] +=
                                  $wig2->[3];    # if ($wig2->[3] > $wig1->[3]);
                                push @merged, $wig1;
                                $wig1 = shift @$set1;
                                $wig2 = shift @$set2;
                            }
                        }
                    }
                }
            }
            while ($wig1) { push @merged, $wig1; $wig1 = shift @$set1 }
            while ($wig2) { push @merged, $wig2; $wig2 = shift @$set2 }
            return \@merged;
        }
        else {
            return $set1;
        }
    }
    else {
        return $set2;
    }
}

sub merge_adjacents {
    my $wigs = shift;
    my @merged;
    my $prev;
    for my $wig ( sort { $a->[0] cmp $b->[0] or $a->[1] <=> $b->[1] } @$wigs ) {
        if (    $prev
            and $wig->[0] eq $prev->[0]
            and $wig->[1] <= $prev->[2]
            and $wig->[3] == $prev->[3] )
        {
            $prev->[2] = $wig->[2] if ( $wig->[2] > $prev->[2] );
        }
        else {
            push @merged, $prev if $prev;
            $prev = $wig;
        }
    }
    push @merged, $prev if $prev;
    return \@merged;
}

sub cluster_votes {
    my $votes = shift;

    my %cluster;
    my @clusters;
    for my $pos ( sort { $a->[0] cmp $b->[0] or $a->[1] <=> $b->[1] } @$votes )
    {
        my ( $seqid, $start, $end ) = @$pos;
        $start--;    # because we expect half open intervals
        if (    %cluster
            and $seqid eq $cluster{SEQID}
            and $start <= $cluster{END} )
        {            # overlaps with previous cluster
            $cluster{DEPTH}{$start} =
              exists $cluster{DEPTH}{$start} ? $cluster{DEPTH}{$start} + 1 : 1;
            $cluster{DEPTH}{$end} =
              exists $cluster{DEPTH}{$end} ? $cluster{DEPTH}{$end} - 1 : -1;
            if ( $end > $cluster{END} ) {
                $cluster{END} = $end;
            }
        }
        else {

            # output previous cluster
            push @clusters, score_cluster( \%cluster ) if %cluster;

            # create a new cluster
            %cluster = (
                SEQID => $seqid,
                END   => $end,
                DEPTH => { $start => 1, $end => -1 }
            );
        }
    }

    # output last cluster
    push @clusters, score_cluster( \%cluster ) if %cluster;
    return \@clusters;
}

sub score_cluster {
    my $cluster = shift;
    my @intervals;
    my @positions = sort { $a <=> $b } keys %{ $cluster->{DEPTH} };
    my $prev_pos  = shift @positions;
    my $depth     = $cluster->{DEPTH}{$prev_pos};
    my $max_depth = $depth;
    for my $pos (@positions) {
        $cluster->{DEPTH}{$pos} or next;
        push @intervals, [ $cluster->{SEQID}, $prev_pos, $pos, $depth ];
        $max_depth = $depth if $depth > $max_depth;
        $depth += $cluster->{DEPTH}{$pos};
        $prev_pos = $pos;
    }
    return [ \@intervals, $max_depth ];
}

sub output_agp {
    my $scaffold = 0;
    for my $root ( keys %{ $uf->{is_root} } ) {
        my $size = scalar @{ $uf->{neighbors}{$root} };
        next if ( $size == 1 and $nodes->[$root][0] eq 'agp' );
        my %parent;
        for my $node ( @{ $uf->{neighbors}{$root} } ) {
            if ( exists $edges->{$node} ) {
                for my $to ( keys %{ $edges->{$node} } ) {
                    $parent{$to}{$node} = 1;
                }
            }
        }

        # adapted from Wikipedia Topological_sorting article
        my @L;    # empty list that will contain sorted elements
        my @S;    # set of nodes with no incoming edges
        @S = grep { not exists $parent{$_} } @{ $uf->{neighbors}{$root} };
        while (@S) {
            my $n = shift @S;
            push @L, $n;
            my @to = keys %{ $edges->{$n} };
            $edges->{$n} = {};
            for my $m (@to) {
                delete $parent{$m}{$n};
                if ( not keys %{ $parent{$m} } ) {
                    push @S, $m;
                }
            }
        }
        $scaffold++;
        my $i   = 0;
        my $pos = 1;
        for my $node (@L) {
            $i++;
            my ( $class, $name, $dir, $fl, $from, $to ) = @{ $nodes->[$node] };
            my $len = $to - $from;
            print join( "\t",
                "GeneScaffold_" . $scaffold,
                $pos, $pos + $len,
                $i, 'D', $name, $from, $to, $dir == 1 ? '+' : '-',
                $uf->AGP_range($node) ),
              "\n";
            $pos += $len + 1;
            if ( $node != $L[-1] ) {
                $i++;
                print join( "\t",
                    "GeneScaffold_" . $scaffold,
                    $pos, $pos + 49, $i, 'N', '50', 'fragment', 'no', '',
                    'NA' ),
                  "\n";
                $pos += 50;
            }
        }
    }
}

sub output_graph {
    my $scaffold = 0;
    for my $root ( $uf->Roots() ) {
        my @chars = split //, $root;
        my $size = scalar @{ $uf->{neighbors}{$root} };
        next if ( $size == 1 and $nodes->[$root][0] eq 'agp' );
        $scaffold++;

        #    my $path = join( "/", $outdir, $size, @chars );
        #    system("mkdir -p $path");
        #    open( G, ">", "$path/$root.dot" )
        #      or die "failed to open $path/$root.dot : $!\n";
        open( G, ">", "$outdir/scaffold_$scaffold.dot" )
          or die "failed to open $outdir/scaffold_$scaffold.dot: $!\n";
        print G "digraph G {\nrankdir=LR\n";
        my $n_leaves = 0;
        my %has_parent = map { $_ => 0 } @{ $uf->{neighbors}{$root} };

        for my $node ( @{ $uf->{neighbors}{$root} } ) {
            if ( keys %{ $edges->{$node} } ) {
                for my $to ( keys %{ $edges->{$node} } ) {
                    my %seqs;
                    for my $s ( @{ $edges->{$node}{$to}[3] } ) {
                        $seqs{$s} = 1;
                    }
                    print G "$node -> $to [label=\"",
                      join( '\n', keys %seqs ), "\"];\n";
                    $has_parent{$to} = 1;
                }
            }
            else {
                $n_leaves++;
            }
        }
        my $n_roots = 0;
        for my $node ( keys %has_parent ) {
            $has_parent{$node} or $n_roots++;
        }

        #    print "$path/$root.dot\t$size\t$n_roots\t$n_leaves\n";
        for my $node ( @{ $uf->{neighbors}{$root} } ) {
            print G "$node [shape=box]\n";
            my ( $class, $name, $dir, $fl, $from, $to, $rnas ) =
              @{ $nodes->[$node] };
            for my $rna (@$rnas) {
                print join( "\t", $root, $name, $dir, $from, $to, $rna ), "\n";
            }
            if ( $class eq 'agp' ) {
                print G
                  "$node [shape=record, label=\"{ $from | $name | $to }\"]\n";
            }
            else {
                my $color = $dir == 1 ? "blue" : "red";
                print G
"$node [shape=box, label=\"$name\", style=\"rounded,filled\", fillcolor=$color]\n";
            }
        }
        print G "}\n";
        close G;
    }
}
