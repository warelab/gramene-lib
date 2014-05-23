package GeneScaffold;

use strict;
use FastaIndex;
use TwoBit;
use myAlign;
use UnionFind;

my %p;
my %defaults = (
    min_identity => 0.9,
    overlap      => 30,
    verbose      => 0,
    min_new      => 10,
    max_intron   => 100000,
    padding      => 1000000,
    max2fetch    => 10,
    min_coverage => 0.5,
    dump_gaps    => 0,
    softmask     => 0,
    scaffolds    => 0,
    verbose      => 0,
    agp_file     => [],
    gbs_file     => [],
    syn_file     => [],
    dmz_file     => [],
    dna_file     => 0,
    DMZ_buffer   => 50,
    check_strand => 0
);

my @params = (
    'min_identity=f', 'overlap=i',      'min_new=i',   'max_intron=i',
    'max2fetch=i',    'min_coverage=f', 'agp_file=s@', 'gbs_file=s@',
    'syn_file=s@',    'dump_gaps=s',    'softmask=s',  'padding=i',
    'verbose=i',      'scaffolds=s',    'dna_file=s',  'dmz_file=s@',
    'DMZ_buffer=i',   'check_strand=i'
);

my @PSL = (
    'match',       'mismatch',    'rep_match',   'Ns',
    'q_gap_count', 'q_gap_bases', 't_gap_count', 't_gap_bases',
    'strand',      'q_name',      'q_size',      'q_start',
    'q_end',       't_name',      't_size',      't_start',
    't_end',       'block_count', 'blockSizes',  'qStarts',
    'tStarts'
);

my ( %DMZ, %AGP, %gpos, %synteny_map, $aligner );

sub new {
    my $name  = shift;
    my $class = ref($name) || $name;
    my $this  = {};
    bless $this, $class;
    return $this;
}

sub params {
    my $this = shift;
    return @params;
}

sub args {
    my ( $this, $user ) = @_;
    for my $k ( keys %defaults ) {
        exists $p{$k}
          or $p{$k} = exists $$user{$k} ? $$user{$k} : $defaults{$k};
    }
    my @args;
    for my $k ( keys %p ) {
        if ( ref $p{$k} eq 'ARRAY' ) {
            for my $value ( @{ $p{$k} } ) {
                push @args, "--$k $value";
            }
        }
        else {
            push @args, "--$k $p{$k}";
        }
    }
    return join " ", @args;
}

sub init {
    my $this = shift;
    $this->{uf}      = new UnionFind;
    $this->{nodes}   = [];
    $this->{edges}   = {};
    $this->{offsets} = {};
    $this->{bridges} = {};
    @{ $p{dmz_file} } and $this->load_DMZ( @{ $p{dmz_file} } );
    @{ $p{agp_file} } and $this->load_AGP( @{ $p{agp_file} } );
    @{ $p{gbs_file} } and $this->load_GBS( @{ $p{gbs_file} } );
    @{ $p{syn_file} } and $this->load_SYN( @{ $p{syn_file} } );
    if ( $p{softmask} ) {

        if ( $p{softmask} =~ m/2bit$/ ) {
            $p{contig_fidx1} = new TwoBit;
            $p{contig_fidx1}->load( $p{softmask} );
        }
        else {
            $p{contig_fidx1} = new FastaIndex;
            $p{contig_fidx1}->load( $p{softmask} );
        }
    }
    elsif ( $p{dump_gaps} ) {
        if ( $p{dump_gaps} =~ m/2bit$/ ) {
            $p{contig_fidx2} = new TwoBit;
            $p{contig_fidx2}->load( $p{dump_gaps} );
        }
        else {
            $p{contig_fidx2} = new FastaIndex;
            $p{contig_fidx2}->load( $p{dump_gaps} );
        }
    }
    elsif ( $p{scaffolds} ) {
        if ( $p{scaffolds} =~ m/2bit$/ ) {
            $p{contig_fidx3} = new TwoBit;
            $p{contig_fidx3}->load( $p{scaffolds} );
        }
        else {
            $p{contig_fidx3} = new FastaIndex;
            $p{contig_fidx3}->load( $p{scaffolds} );
        }
    }
    if ( $p{dna_file} ) {
        $p{dna_idx} = new TwoBit;
        $p{dna_idx}->load( $p{dna_file} );
    }
    $aligner = myAlign->new();
}

sub load_2bit {
    my ( $this, $twoBit ) = @_;
    my %seqlen;
    my $cmd = "twoBitInfo $twoBit /dev/fd/1";
    open( IN, "$cmd |" ) or die "failed to run $cmd: $!\n";
    while (<IN>) {
        chomp;
        my ( $seq, $len ) = split /\t/, $_;
        $seqlen{$seq} = $len;
    }
    return \%seqlen;
}

sub load_DMZ {
    my ( $this, @dmz_files ) = @_;
    my $sorted = 1;
    for my $dmz_file (@dmz_files) {
        print STDERR "load_DMZ($dmz_file)" if $p{verbose};
        open( my $fh, "<", $dmz_file ) or die "failed to open $dmz_file: $!\n";
        while (<$fh>) {
            chomp;
            my ( $chr, $strand, $from, $to, $id ) = split /\t/, $_;
            $chr = "chr$chr";
            if ( exists $DMZ{$chr}{$strand} ) {
                $sorted = 0
                  if ( $sorted and $from < $DMZ{$chr}{$strand}[-1][0] );
                push @{ $DMZ{$chr}{$strand} }, [ $from, $to ];
            }
            else {
                $DMZ{$chr}{$strand} = [ [ $from, $to ] ];
            }
        }
        close $fh;
        print STDERR " done\n" if $p{verbose};
    }
    if ( not $sorted ) {
        print STDERR "sorting dmz intervals" if $p{verbose};
        for my $chr ( keys %DMZ ) {
            for my $strand ( keys %{ $DMZ{$chr} } ) {
                my @intervals =
                  sort { $a->[0] <=> $b->[0] } @{ $DMZ{$chr}{$strand} };
                $DMZ{$chr}{$strand} = \@intervals;
            }
        }
        print STDERR " done\n" if $p{verbose};
    }

    # now that we know everything is sorted, merge overlapping intervals
    print STDERR "clustering dmz intervals" if $p{verbose};
    for my $chr ( keys %DMZ ) {
        for my $strand ( keys %{ $DMZ{$chr} } ) {
            my @clusters;
            push @clusters, shift @{ $DMZ{$chr}{$strand} };
            for my $interval ( @{ $DMZ{$chr}{$strand} } ) {
                if ( $interval->[0] <= $clusters[-1][1] ) {
                    if ( $interval->[1] > $clusters[-1][1] ) {
                        $clusters[-1][1] = $interval->[1];
                    }
                }
                else {
                    push @clusters, $interval;
                }
            }
            $DMZ{$chr}{$strand} = \@clusters;
        }
    }
    print STDERR " done\n" if $p{verbose};
}

sub load_AGP {
    my ( $this, @agp_files ) = @_;

    for my $agp_file (@agp_files) {
        print STDERR "load_AGP($agp_file)" if $p{verbose};
        if ( $agp_file =~ m/\.gz$/ ) {
            $agp_file = "gzip -cd $agp_file |";
        }
        open( IN, $agp_file ) or die "failed to open $agp_file: $!\n";
        while (<IN>) {
            chomp;
            my ( $chr, $from, $to, $i, $DN, @etc ) = split /\t/, $_;
			$DN or next;
            $from--;
            $chr = "chr$chr" if $chr =~ m/^\d+$/;
            if ( $DN eq 'D' ) {
                if ( $AGP{$chr} and $AGP{$chr}[-1][-1] == $from ) {
                    $AGP{$chr}[-1][-1] = $to;
                }
                else {
                    push @{ $AGP{$chr} }, [ $from, $to ];
                }
            }
        }
        close IN;
        print STDERR " done\n" if $p{verbose};
    }

    my $offsets = $this->{offsets};
    my $uf      = $this->{uf};
    my $nodes   = $this->{nodes};

    # add nodes to the graph
    for my $chr ( keys %AGP ) {
        $offsets->{$chr} = @$nodes;
        for ( my $i = 0 ; $i < @{ $AGP{$chr} } ; $i++ ) {
            my $n = @$nodes;
            $uf->MakeSet( $n, [ $chr, @{ $AGP{$chr}[$i] }, 1, 1 ] );
            push @$nodes, [ 'agp', $chr, 1, 0, @{ $AGP{$chr}[$i] }, [] ];
        }
    }
}

sub load_GBS {
    my ( $this, @gbs_files ) = @_;
    for my $gbs_file (@gbs_files) {
        print STDERR "load_GBS($gbs_file)" if $p{verbose};
        open( IN, $gbs_file ) or die "failed to open $gbs_file: $!\n";
        while (<IN>) {
            chomp;
            /^[0-9]/ or next;
            my ( $seqid, $chr, $start, $end, $mean ) = split /\t/, $_;
            exists $gpos{$seqid}
              and die
              "$seqid already exists in gpos hash! reading from $gbs_file\n";
            $gpos{$seqid} = [ "chr$chr", $start, $end, 0, 0, 'G' ];
        }
        close IN;
        print STDERR " done\n" if $p{verbose};
    }
}

sub load_SYN {
    my ( $this, @syn_files ) = @_;
    for my $infile (@syn_files) {
        print STDERR "load_SYN($infile)" if $p{verbose};
        open( IN, "<", $infile )
          or die "failed to open $infile for reading:$!\n";
        while (<IN>) {
            chomp;
            my (
                $seqid,  $syn_gene,       $subgenome,
                $chr,    $from,           $to,
                $method, $sb_gene_strand, $syn_block_id,
                $q_id_orientation
            ) = split /\t/, $_;
            $method           = "non-direct" if $method ne "direct";
            $q_id_orientation = 0            if $q_id_orientation !~ /^-?1$/;
            $chr              = "chr$chr"    if $chr !~ m/^chr/;
            $synteny_map{$seqid}{$chr} =
              [ $from, $to, $q_id_orientation, 0, 'S' ];
        }
        close IN;
        print STDERR " done\n" if $p{verbose};
    }
}

sub read_next {
    my ( $this, $fh ) = @_;
    my @hits;
    my $pos = tell $fh;
    my $seq;
    while (<$fh>) {
        /^[0-9]/ or next;
        my %hit;
        chomp;
        my @c = split /\t/, $_;
        for ( my $i = 0 ; $i < @c ; $i++ ) {
            $hit{ $PSL[$i] } = $c[$i];
        }
        if ( $seq and $hit{q_name} ne $seq ) {
            seek( $fh, $pos, 0 );
            return \@hits;
        }
        $seq = $hit{q_name};
        push @hits, \%hit;
        $pos = tell $fh;
    }
    return @hits ? \@hits : undef;
}

sub read_hits {
    my ( $this, $seq, $fh ) = @_;

    my @hits;
    my $pos = tell $fh;
    while (<$fh>) {
        /^[0-9]/ or next;
        my %hit;
        chomp;
        my @c = split /\t/, $_;
        for ( my $i = 0 ; $i < @c ; $i++ ) {
            $hit{ $PSL[$i] } = $c[$i];
        }
        if ( $hit{q_name} ne $seq ) {
            seek( $fh, $pos, 0 );
            return ( \@hits, 0 );
        }
        $pos = tell $fh;
        if ( identity( \%hit ) < $p{min_identity} ) {
            print STDERR "identity: ", identity( \%hit ),
              " < $p{min_identity}\n"
              if $p{verbose};
            next;
        }
        if ( my ( $contig, $len, $from, $to ) =
            $hit{t_name} =~ m/(\d+):(\d+):(\d+):(\d+)/ )
        {
            $hit{t_name} = $contig;
            $hit{t_start} += $from;
            $hit{t_end}   += $from;
            $hit{t_size} = $len;
            my @tStarts = split /,/, $hit{tStarts};
            for ( my $i = 0 ; $i < $hit{block_count} ; $i++ ) {
                $tStarts[$i] += $from;
            }
            $hit{tStarts} = join( ',', @tStarts ) . ",";
        }

        global_to_local( \%hit );
        push @hits, \%hit;
    }
    return ( \@hits, 1 );
}

sub global_to_local {
    my $hit = shift;
    $AGP{ $hit->{t_name} } or return;
    for my $k (qw(t_size t_name t_start t_end tStarts)) {
        $hit->{"_global_$k"} = $hit->{$k};
    }
    my $start_idx =
      binary_search_intervals( $hit->{t_start}, $AGP{ $hit->{t_name} },
        0, scalar @{ $AGP{ $hit->{t_name} } } );
    my $end_idx =
      binary_search_intervals( $hit->{t_end}, $AGP{ $hit->{t_name} },
        0, scalar @{ $AGP{ $hit->{t_name} } } );
    my $from =
      $start_idx ? $AGP{ $hit->{t_name} }[$start_idx][0] : $hit->{t_start};

    my $to = $end_idx ? $AGP{ $hit->{t_name} }[$end_idx][1] : $hit->{t_end};
    $hit->{t_size} = $to - $from;
    $hit->{t_start} -= $from;
    $hit->{t_end}   -= $from;
    $hit->{t_name} .= ":$from:$to:1:1:A";
    my @tStarts = split /,/, $hit->{tStarts};

    for ( my $i = 0 ; $i < $hit->{block_count} ; $i++ ) {
        $tStarts[$i] -= $from;
    }
    $hit->{tStarts} = join( ',', @tStarts ) . ",";
}

sub local_to_global {
    my $hit = shift;
    $hit->{_global_t_name} or return;
    for my $k (qw(t_size t_name t_start t_end tStarts)) {
        $hit->{$k} = $hit->{"_global_$k"};
    }
}

sub filter_scaffold_hits {
    my ( $this, $hitsref ) = @_;
    my @reference;
    my @denovo;
    for my $hit (@$hitsref) {
        if ( exists $AGP{ $hit->{t_name} } ) {
            push @reference, $hit;
        }
        else {
            push @denovo, $hit;
        }
    }
    my @hits;
    if (@reference) {
        my $ref_coverage = $this->coverage( \@reference );
        if ( $ref_coverage >= 50 or pos_check( \@reference ) ) {
            push @hits, @reference;
        }
        else {
            print STDERR "filter: reference\n" if ( $p{verbose} );
        }
    }
    if (@denovo) {
        my $dnv_coverage = $this->coverage( \@denovo );
        if ( $dnv_coverage >= 50 ) {
            push @hits, @denovo;
        }
        else {
            print STDERR "filter: denovo\n" if ( $p{verbose} );
        }
    }
    @hits or return [];
    my @sorted = sort by_qstart @hits;
    return \@sorted;
}

sub pos_check {
    my $hitsref = shift;

    for my $hit (@$hitsref) {
        my @t_pos = ( $hit->{t_name}, $hit->{t_start}, $hit->{t_end} );
        my $found = 0;
        if ( exists $gpos{ $hit->{q_name} } ) {
            my @g_pos = @{ $gpos{ $hit->{q_name} } };
            my @overlap =
              intersect_ranges( \@t_pos, expand_range( \@g_pos, $p{padding} ) );
            @overlap and $found = 1;
        }
        if ( not $found and exists $synteny_map{ $hit->{q_name} }{ $t_pos[0] } )
        {
            my @g_pos = (
                $t_pos[0],
                $synteny_map{ $hit->{q_name} }{ $t_pos[0] }[0],
                $synteny_map{ $hit->{q_name} }{ $t_pos[0] }[0]
            );
            my @overlap =
              intersect_ranges( \@t_pos, expand_range( \@g_pos, $p{padding} ) );
            @overlap and $found = 1;
        }
        if ( not $found ) {
            return 0;
        }
    }
    return 1;
}

sub check_interval {
    my ( $n, $from, $to ) = @_;
    if ( defined $from and $n < $from ) { return -1; }
    if ( defined $to   and $n > $to )   { return 1; }
    return 0;
}

sub binary_search_intervals {
    my ( $n, $intervals, $a, $b ) = @_;
    if ( $a == $b ) {
        my $check = check_interval( $n, @{ $intervals->[$a] } );
        return $check == 0 ? $a : undef;
    }
    my $mid = int( ( $a + $b ) / 2 );
    my $check = check_interval( $n, @{ $intervals->[$mid] } );
    if ( $check == 1 ) {
        return binary_search_intervals( $n, $intervals, $mid + 1, $b );
    }
    if ( $check == -1 ) {
        $a == $mid and return undef;
        return binary_search_intervals( $n, $intervals, $a, $mid - 1 );
    }
    return $mid;
}

sub bs_previous {
    my ( $n, $intervals, $a, $b ) = @_;
    if ( $a == $b ) {
        my $check = check_interval( $n, @{ $intervals->[$a] } );
        return $check >= 0 ? $a - $check : -1;
    }
    my $mid = int( ( $a + $b ) / 2 );
    my $check = check_interval( $n, @{ $intervals->[$mid] } );
    if ( $check == 1 ) {
        return bs_previous( $n, $intervals, $mid + 1, $b );
    }
    if ( $check == -1 ) {
        $a == $mid and return -1;
        return bs_previous( $n, $intervals, $a, $mid - 1 );
    }
    return $mid;
}

sub range_query {
    my ( $intervals, $from, $to ) = @_;
    $from < $to or return 0;
    my $previous_interval =
      bs_previous( $to, $intervals, 0, scalar @$intervals );
    $previous_interval >= 0 or return 0;
    return (  $intervals->[$previous_interval][1] > $from
          and $intervals->[$previous_interval][1] < $to );
}

sub query_DMZ {
    my ( $chr, $strand, $from, $to ) = @_;
    print STDERR "query_DMZ($chr,$strand,$from,$to)\n" if $p{verbose};
    if ( exists $DMZ{$chr}{$strand} ) {
        return range_query(
            $DMZ{$chr}{$strand},
            $from + $p{DMZ_buffer},
            $to - $p{DMZ_buffer}
        );
    }
    return 0;
}

sub hitlen {
    my $hitref = shift;
    return $hitref->{q_end} - $hitref->{q_start};

    # see split_qgaps.pl - where alignments with long qgaps are split
}

sub identity {
    my $hitref = shift;
    return ( $hitref->{match} + $hitref->{rep_match} ) / hitlen($hitref);
}

sub hit_coverage {
    my $hitref = shift;
    return hitlen($hitref) / $hitref->{q_size};
}

sub by_qstart {
    $a->{q_start} <=> $b->{q_start}
      or $a->{t_name} cmp $b->{t_name}
      or $a->{t_start} <=> $b->{t_start};
}

sub print_scaffold {
    my $this     = shift;
    my $scaffold = shift;
    for my $hit (@$scaffold) {    ###by_qstart @$scaffold ) {
        local_to_global($hit);
        print join( "\t", map { $hit->{$_} } @PSL ), "\n";
    }
}

sub multi_scaffolds {
    my $this = shift;
    my $hits = shift;
    my @results;
    for ( my $i = 0 ; $i < $p{max2fetch} ; $i++ ) {
        my ( $scaffold, $range ) = $this->greedy_scaffold($hits);
        my $coverage = $this->coverage($scaffold);
        if ( $coverage / $hits->[0]{q_size} > $p{min_coverage} ) {
            push @results, [ $scaffold, $range ];
        }
        else {
            print STDERR "coverage: ", $coverage / $hits->[0]{q_size},
              " > $p{min_coverage}\n"
              if $p{verbose};
        }

        # remove the hits that went into the scaffold from further consideration
        my @leftovers;
        for my $hit (@$hits) {
            my $diff = 0;
            for my $hit2 (@$scaffold) {
                $diff = 0;
                for my $field (@PSL) {
                    if ( $$hit{$field} ne $$hit2{$field} ) {
                        $diff = 1;
                        last;
                    }
                }
                $diff or last;
            }
            $diff and push @leftovers, $hit;
        }
        @leftovers or last;
        $hits = \@leftovers;
    }
    return \@results;
}

sub greedy_scaffold {
    my $this = shift;
    my $hits = shift;

    # sort the hits by query start or target name or target start
    my @sorted = sort by_qstart @$hits;

    # start with an empty scaffold
    return extend_scaffold( [], \@sorted, [] );
}

sub extend_scaffold {
    my ( $scaffold, $hits, $range ) = @_;

    # identify compatible hits.  If none remain, return $scaffold;
    my $compatible_hits = find_compatible_hits( $scaffold, $hits, $range );
    @$compatible_hits or return ( $scaffold, $range );

    # select best hit from among the compatible hits
    my $best = select_best_candidate($compatible_hits);

    # insert the best candidate into an extended scaffold
    my @extended;
    for ( my $i = 0 ; $i < $compatible_hits->[$best]{pos} ; $i++ ) {
        push @extended, $scaffold->[$i];
    }
    push @extended, $hits->[ $compatible_hits->[$best]{idx} ];
    for ( my $i = $compatible_hits->[$best]{pos} ; $i < @$scaffold ; $i++ ) {
        push @extended, $scaffold->[$i];
    }

    # update range if the best hit has a genomic location
    $range = update_range( $range, $compatible_hits->[$best]{range} );

    # assemble a list of the remaining candidate hits
    my @remaining_hits;
    for my $compatible_hit (@$compatible_hits) {
        if ( $compatible_hit->{idx} != $best ) {
            push @remaining_hits, $hits->[ $compatible_hit->{idx} ];
        }
    }

    # recurse with remaining candidate hits
    return extend_scaffold( \@extended, \@remaining_hits, $range );
}

sub find_compatible_hits {
    my ( $scaffold, $hits, $range ) = @_;
    my @compatible;

    my $sidx = 0;    # index into @$scaffold

  HIT: for ( my $hidx = 0 ; $hidx < @$hits ; $hidx++ ) {
        my $hit = $hits->[$hidx];

        # skip hits that cannot be extended
        if ( $hit->{q_start} > $p{min_new}
            and long_flank( $hit, 1, $p{max_intron} ) )
        {
            print STDERR "long_flank L: ",
              join( "\t", map { $hit->{$_} } @PSL ), "\n"
              if $p{verbose};

            #next;
        }
        if ( $hit->{q_size} - $hit->{q_end} > $p{min_new}
            and long_flank( $hit, 0, $p{max_intron} ) )
        {
            print STDERR "long_flank R: ",
              join( "\t", map { $hit->{$_} } @PSL ), "\n"
              if $p{verbose};

            #next;
        }

        # skip hits where GBS of cDNA disagrees with
        # GBS of contig or alignment position
        if ( not internally_consistent($hit) ) {
            print STDERR "internally inconsistent: ",
              join( "\t", map { $hit->{$_} } @PSL ), "\n"
              if $p{verbose};
            next;
        }

        # lookup genetic position for hit
        my $hit_range = choose_gpos($hit);
        if (@$hit_range) {
            if (@$range) {
                my @intersection =
                  intersect_ranges( $range,
                    expand_range( $hit_range, $p{padding} ) );
                if ( not @intersection ) {
                    print STDERR "out of range: ",
                      join( "\t", map { $hit->{$_} } @PSL ), "\n"
                      if $p{verbose};
                    next;
                }
            }
        }

        my $new_coverage = 0;

        # inner loop over the scaffold hits (starting at current)
        while ( $sidx < @$scaffold ) {

            compatible_chr( $hit, $scaffold->[$sidx] ) or next HIT;

            # hit starts before $sidx
            if ( $hit->{q_start} < $scaffold->[$sidx]{q_start} ) {

                # overlap with $sidx is OK
                if ( $hit->{q_end} < $scaffold->[$sidx]{q_start} + $p{overlap} )
                {

                    # check $sidx-1
                    my ( $new_from, $new_to ) = ( 0, 0 );
                    if ( not $sidx ) {
                        $new_from = $hit->{q_start};
                        $new_to =
                            $hit->{q_end} < $scaffold->[$sidx]{q_start}
                          ? $hit->{q_end}
                          : $scaffold->[$sidx]{q_start};
                    }
                    elsif ( $hit->{q_start} >
                        $scaffold->[ $sidx - 1 ]{q_end} - $p{overlap} )
                    {
                        $new_from =
                            $hit->{q_start} > $scaffold->[ $sidx - 1 ]{q_end}
                          ? $hit->{q_start}
                          : $scaffold->[ $sidx - 1 ]{q_end};
                        $new_to =
                            $hit->{q_end} < $scaffold->[$sidx]{q_start}
                          ? $hit->{q_end}
                          : $scaffold->[$sidx]{q_start};
                    }
                    $new_coverage = $new_to - $new_from;
                }
                last;
            }
            else {
                $sidx++;
            }
        }
        my $last = 0;

        # no hits in the scaffold as of yet.
        if ( @$scaffold == 0 ) {
            $new_coverage = $hit->{q_end} - $hit->{q_start};
        }
        elsif ( $sidx == @$scaffold ) {
            $sidx--;
            $last = 1;

            # check if this hit follows the last hit in the scaffold
            if (    $hit->{q_start} > $scaffold->[-1]{q_end} - $p{overlap}
                and $hit->{q_end} > $scaffold->[-1]{q_end} )
            {
                $new_coverage =
                    $hit->{q_start} > $scaffold->[-1]{q_end}
                  ? $hit->{q_end} - $hit->{q_start}
                  : $hit->{q_end} - $scaffold->[-1]{q_end};
            }
        }
        if ( $new_coverage >= $p{min_new} ) {
            push @compatible,
              {
                idx      => $hidx,
                new      => $new_coverage,
                identity => identity($hit),
                pos      => $sidx + $last,
                range    => $hit_range
              };
        }
        else {
            print STDERR " min_new : $new_coverage < $p{min_new} \n"
              if $p{verbose};
        }
    }

    return \@compatible;
}

sub compatible_chr {
    my ( $h, $sh ) = @_;
    my @h_pos  = split /:/, $h->{t_name};
    my @sh_pos = split /:/, $sh->{t_name};

    # only care about hits to chromosomes
    if ( @sh_pos == 6 and @h_pos == 6 ) {

        # same chr
        if ( $h_pos[0] ne $sh_pos[0] ) {
            print STDERR " diff_chr
                      : $h_pos[0] ne $sh_pos[0] \n" if $p{verbose};
            return 0;
        }

        # same strand
        if ( $h->{strand} ne $sh->{strand} ) {
            print STDERR " diff_strand : $$h{strand} ne $$sh{strand} \n"
              if $p{verbose};
            return 0;
        }

        # check if they are compatible w.r.t introns
        my @x =
          sort { $a <=> $b } (
            $h->{t_start} + $h_pos[1],
            $h->{t_end} + $h_pos[1],
            $sh->{t_start} + $sh_pos[1],
            $sh->{t_end} + $sh_pos[1]
          );
        my $intron = $x[2] - $x[1];
        if ( $p{max_intron} < 100 ) {

            # adjust intron length if jumping one gap
            my @y =
              sort { $a <=> $b }
              ( $h_pos[1], $h_pos[2], $sh_pos[1], $sh_pos[2] );
            my $gap = $y[2] - $y[1];
            $intron -= $gap if ( $gap == 100 or $gap == 500 or $gap == 1000 );
        }
        if ( $intron > $p{max_intron} ) {
            print STDERR " intron
                      : $intron > $p{max_intron} \n" if $p{verbose};
            return 0;
        }

        # check if the order and orientation is consistent
        my $q_plus = ( $h->{q_start} < $sh->{q_start} );
        my $t_plus =
          ( $h_pos[1] + $h->{t_start} < $sh_pos[1] + $sh->{t_start} );
        my $s_plus = ( $h->{strand} eq '+' );
        my $pass = ( $q_plus == $t_plus ) ? $s_plus : !$s_plus;
        if ( not $pass ) {
            print STDERR " order and orientation : \n" if $p{verbose};
        }
        return $pass;
    }
    elsif ( $h->{t_name} eq $sh->{t_name} ) {

        # same strand
        if ( $h->{strand} ne $sh->{strand} ) {
            print STDERR " diff_strand : $$h{strand} ne $$sh{strand} \n"
              if $p{verbose};
            return 0;
        }

        # check if they are compatible w.r.t introns
        my @x =
          sort { $a <=> $b }
          ( $h->{t_start}, $h->{t_end}, $sh->{t_start}, $sh->{t_end} );
        if ( $x[2] - $x[1] > $p{max_intron} ) {
            print STDERR " intron : ", $x[2] - $x[1], " > $p{max_intron} \n"
              if $p{verbose};
            return 0;
        }

        # check if the order and orientation is consistent
        my $q_plus = ( $h->{q_start} < $sh->{q_start} );
        my $t_plus = ( $h->{t_start} < $sh->{t_start} );
        my $s_plus = ( $h->{strand} eq '+' );
        my $pass   = ( $q_plus == $t_plus ) ? $s_plus : !$s_plus;
        if ( not $pass ) {
            print STDERR " order and orientation : \n" if $p{verbose};
        }
        return $pass;
    }
    return 1;
}

sub expand_range {
    my ( $range, $size ) = @_;
    my @expanded = @$range;
    $expanded[1] -= $size;
    $expanded[1] = 0 if $expanded[1] < 0;
    $expanded[2] += $size;
    return \@expanded;
}

sub internally_consistent {
    my $hit = shift;

    my $contig_mappings = get_mappings( $hit->{t_name} );
    my $cDNA_mappings   = get_mappings( $hit->{q_name} );

    @$contig_mappings and @$cDNA_mappings or return 1;

    for my $contig_pos (@$contig_mappings) {
        print STDERR join( " \t ", " contig_pos : ", @$contig_pos ), " \n"
          if $p{verbose};
        my $flip_cDNA = $contig_pos->[4] && $contig_pos->[3] == 1;
        for my $cDNA_pos (@$cDNA_mappings) {

            # might have to flip the cDNA orientation
            $cDNA_pos->[3] *= -1 if $flip_cDNA and $hit->{strand} eq '-';
            print STDERR join( " \t ", " cDNA_pos : ", @$cDNA_pos ), " \n"
              if $p{verbose};

            my @overlap = intersect_ranges(
                $contig_pos,
                expand_range(
                    $cDNA_pos,
                    $cDNA_pos->[5] eq 'S' ? 10 * $p{padding} : $p{padding}
                )
            );
            @overlap and return 1;

            # flip it back
            $cDNA_pos->[3] *= -1 if $flip_cDNA and $hit->{strand} eq '-';
        }
    }

    # allow inconsistency between synteny and alignments
    if ( $contig_mappings->[0][5] eq 'A' ) {
        if ( $cDNA_mappings->[0][5] eq 'S' ) {
            print STDERR " overridden inconsistency A/S\n" if $p{verbose};
            return 1;
        }
        elsif ( $cDNA_mappings->[0][5] eq 'G'
            and hitlen($hit) > 70
            and hit_coverage($hit) > 0.3
            and identity($hit) > 0.99 )
        {
            print STDERR " overridden inconsistency A/G\n" if $p{verbose};
            return 1;
        }
    }
    return 0;
}

sub get_mappings {
    my $k = shift;
    my @by_definition = split /:/, $k;
    if ( @by_definition == 6 ) {
        return [ \@by_definition ];
    }
    elsif ( @by_definition > 1 ) {
        die " should have been 6 fields in '$k' \n";
    }

    exists $gpos{$k} or exists $synteny_map{$k} or return [];

    my @mappings;
    if ( exists $gpos{$k} ) {
        push @mappings, $gpos{$k};
    }
    if ( exists $synteny_map{$k} ) {
        for my $chr ( keys %{ $synteny_map{$k} } ) {
            my ( $from, $to, $direction, $fixed, $type ) =
              @{ $synteny_map{$k}{$chr} };
            push @mappings, [ $chr, $from, $to, $direction, $fixed, $type ];
        }
    }
    return \@mappings;
}

# given a contig and the cDNA that picked it, lookup possible locations on the reference.
# choose the most specific position range available.  in the event of a conflict
# don't assign a position.
sub choose_gpos {
    my $hit        = shift;
    my $contig     = $hit->{t_name};
    my $cDNA       = $hit->{q_name};
    my @contig_pos = split /:/, $hit->{t_name};

    @contig_pos == 6 and return \@contig_pos;

    my @contig_gbs = exists $gpos{$contig} ? @{ $gpos{$contig} } : ();
    my @cDNA_gbs   = exists $gpos{$cDNA}   ? @{ $gpos{$cDNA} }   : ();

    my @range = intersect_ranges( \@contig_gbs, \@cDNA_gbs );

    if (@range) {

        # try to refine genetic range with synteny
        my @contig_syn = ();
        if ( exists $synteny_map{$contig}
            and $synteny_map{$contig}{ $range[0] } )
        {
            @contig_syn =
              ( $range[0], @{ $synteny_map{$contig}{ $range[0] } } );
        }
        my @cDNA_syn = ();
        if ( exists $synteny_map{$cDNA}
            and $synteny_map{$cDNA}{ $range[0] } )
        {
            @cDNA_syn = ( $range[0], @{ $synteny_map{$cDNA}{ $range[0] } } );
        }
        my @syn   = intersect_ranges( \@contig_syn, \@cDNA_syn );
        my @agree = intersect_ranges( \@range,      \@syn );
        @agree and return \@agree;
        @agree = intersect_ranges( \@range, \@contig_syn ) if @contig_syn;
        @agree and return \@agree;
        @agree = intersect_ranges( \@range, \@cDNA_syn ) if @cDNA_syn;
        @agree and return \@agree;

        # try the fattened range
        my $fatrange = expand_range( \@range, $p{padding} );
        @agree = intersect_ranges( $fatrange, \@syn );
        @agree and return \@agree;
        @agree = intersect_ranges( $fatrange, \@contig_syn ) if @contig_syn;
        @agree and return \@agree;
        @agree = intersect_ranges( $fatrange, \@cDNA_syn ) if @cDNA_syn;
        @agree and return \@agree;
        return \@range;
    }
    else {
        ### don't let synteny alone place contigs
        return [];
        my @contig_syn = ();
        if ( exists $synteny_map{$contig} ) {
            for my $chr ( keys %{ $synteny_map{$contig} } ) {
                @contig_syn = ( $chr, @{ $synteny_map{$contig}{$chr} } );
                print STDERR join( " \t ",
                    "    #unmapped contig#",
                    $contig, $cDNA, @contig_syn ),
                  "\n";
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
        print STDERR "inconsistent chr\n" if $p{verbose};
        return ();
    }
    my $strand = 0;
    my $fixed = $r1->[4] || $r2->[4];
    if (    $p{check_strand}
        and $fixed
        and $r1->[3]
        and $r2->[3]
        and $r1->[3] != $r2->[3] )
    {                                # different strands
        print STDERR "inconsistent strand\n" if $p{verbose};
        return ();
    }
    $strand = $r1->[3] || $r2->[3];
    if ( $r1->[2] >= $r2->[1] and $r1->[1] <= $r2->[2] ) {   # intervals overlap
        my @x =
          sort { $a <=> $b } ( $r1->[1], $r1->[2], $r2->[1], $r2->[2] );
        return ( $r1->[0], $x[1], $x[2], $strand, $fixed );
    }
    print STDERR "inconsistent intervals\n" if $p{verbose};
    return ();
}

sub update_range {
    my ( $r1, $r2 ) = @_;
    my @merged = ();
    if (@$r1) {
        @merged = @$r1;
        if (@$r2) {
            if ( $r2->[1] < $merged[1] ) {
                $merged[1] = $r2->[1];
            }
            if ( $r2->[2] > $merged[2] ) {
                $merged[2] = $r2->[2];
            }
        }
    }
    elsif (@$r2) {
        @merged = @$r2;
    }
    return \@merged;
}

sub select_best_candidate {
    my $candidates = shift;
    my $best_score = 0;
    my $best_idx;
    for ( my $i = 0 ; $i < @$candidates ; $i++ ) {
        my $score = $candidates->[$i]{new} * $candidates->[$i]{identity};
        if ( $score > $best_score ) {
            $best_score = $score;
            $best_idx   = $i;
        }
    }
    return $best_idx;
}

# determine whether the left (right) flank is longer than MAX_INTRON
sub long_flank {
    my ( $hit, $left, $max_flank ) = @_;
    if ($left) {
        if ( $$hit{strand} eq '+' ) {
            return $$hit{t_start} > $max_flank;
        }
        else {
            return $$hit{t_size} - $$hit{t_end} + 1 > $max_flank;
        }
    }
    else {    # right flank
        if ( $$hit{strand} eq '+' ) {
            return $$hit{t_size} - $$hit{t_end} + 1 > $max_flank;
        }
        else {
            return $$hit{t_start} > $max_flank;
        }
    }
}

sub coverage {
    my ( $this, $scaffold ) = @_;
    @$scaffold or return 0;
    my @hits     = sort by_qstart @$scaffold;
    my $hit      = shift @hits;
    my $max      = $$hit{q_end};
    my $coverage = $$hit{q_end} - $$hit{q_start};
    for $hit (@hits) {
        if ( $$hit{q_end} > $max ) {
            if ( $$hit{q_start} > $max ) {
                $coverage += $$hit{q_end} - $$hit{q_start};
            }
            else {
                $coverage += $$hit{q_end} - $max;
            }
            $max = $$hit{q_end};
        }
    }
    return $coverage;
}

sub dump_gaps {
    my ( $this, $seqid, $len, $scaffold ) = @_;
    my $seq = $p{contig_fidx2}->fetch($seqid);
    $seq or die "can't find $seqid in FastaIndex\n";
    my $pos = 0;
    for my $hit (@$scaffold) {
        if ( $hit->{q_start} - $pos > $p{min_new} ) {

            # output the gap
            my $from = $pos < 10 ? 0 : $pos - 10;
            my $to = $len - $hit->{q_start} < 10 ? $len : $hit->{q_start} + 10;
            my $subseq = substr( $seq, $from, $to - $from );
            print ">$seqid:$len:$from:$to\n$subseq\n";
        }
        $pos = $hit->{q_end} if ( $hit->{q_end} > $pos );
    }
    if ( $len - $pos > $p{min_new} ) {
        my $from   = $pos < 10 ? 0 : $pos - 10;
        my $to     = $len;
        my $subseq = substr( $seq, $from, $to - $from );
        print ">$seqid:$len:$from:$to\n$subseq\n";
    }
}

sub dump_softmasked {
    my ( $this, $seqid, $len, $scaffold ) = @_;
    my $seq = $p{contig_fidx1}->fetch($seqid);
    $seq or die "can't find $seqid in FastaIndex\n";
    my @nucs = split //, $seq;
    my $pos  = 0;
    my $good = 0;
    for my $hit (@$scaffold) {
        if ( $hit->{q_start} - $pos > $p{min_new} ) {
            $good = 1;
        }
        $pos = $hit->{q_end} if ( $hit->{q_end} > $pos );
        for ( my $i = $hit->{q_start} ; $i < $hit->{q_end} ; $i++ ) {
            $nucs[$i] = lc $nucs[$i];
        }
    }
    if ( $len - $pos > $p{min_new} ) {
        $good = 1;
    }
    $good or return;
    print ">$seqid\n", join( '', @nucs ), "\n";
}

sub add_scaffold_to_graph {
    my $this      = shift;
    my $hits      = shift;
    my $recursion = shift;

    my $offsets = $this->{offsets};
    my $nodes   = $this->{nodes};
    my $edges   = $this->{edges};
    my $uf      = $this->{uf};

    my $rna_name = $hits->[0]{q_name};

    # check if there is a hit to the agp -> anchors the orientation
    my $oriented = 0;
    for my $hit (@$hits) {
        if ( $AGP{ $hit->{t_name} } ) {
            $oriented = $hit->{strand};
            last;
        }
    }
    my $fix = 1;
    if ( $oriented == -1 ) {
        $hits     = flip($hits);
        $fix      = -1;
        $oriented = 1;
    }

    # add new nodes to the graph
    for my $hit (@$hits) {
        my $ctg = $hit->{t_name};
        my $rna_hit = join( "\t", $rna_name, $hit->{q_start}, $hit->{q_end} );
        if ( not exists $offsets->{$ctg} ) {
            $offsets->{$ctg} = @$nodes;
            $uf->MakeSet( $offsets->{$ctg}, choose_gpos($hit) );
            push @$nodes,
              [
                'abyss', $ctg,
                $hit->{strand}, $oriented ? 0 : 1,
                0, $hit->{t_size},
                [$rna_name]
              ];
        }
        else {
            my $node_idx = $offsets->{$ctg};
            if ( $AGP{ $hit->{t_name} } ) {
                $node_idx +=
                  binary_search_intervals( $hit->{t_start},
                    $AGP{ $hit->{t_name} },
                    0, scalar @{ $AGP{ $hit->{t_name} } } );
            }
            push @{ $nodes->[$node_idx][6] }, $rna_name;
        }
    }

    # connect edges
    for ( my $i = 1 ; $i < @$hits ; $i++ ) {

        # previous node
        my $p_hit  = $hits->[ $i - 1 ];
        my $p_ctg  = $p_hit->{t_name};
        my $p_node = $offsets->{$p_ctg};
        if ( $AGP{$p_ctg} ) {
            $p_node +=
              binary_search_intervals( $p_hit->{t_end}, $AGP{$p_ctg}, 0,
                scalar @{ $AGP{$p_ctg} } );
        }

        # current node
        my $c_hit  = $hits->[$i];
        my $c_ctg  = $c_hit->{t_name};
        my $c_node = $offsets->{$c_ctg};
        if ( $AGP{$c_ctg} ) {
            $c_node +=
              binary_search_intervals( $c_hit->{t_start}, $AGP{$c_ctg}, 0,
                scalar @{ $AGP{$c_ctg} } );
        }

        # check for existing gene models that we don't want to jump over
        if ( $AGP{$p_ctg} ) {
            my ( $downstream_start, $downstream_end );
            if ( $p_hit->{strand} == 1 ) {
                $downstream_start = $p_hit->{t_end};
                $downstream_end   = $nodes->[$p_node][5];
            }
            else {
                $downstream_start = $nodes->[$p_node][4];
                $downstream_end   = $p_hit->{t_start};
            }
            if (
                query_DMZ(
                    $p_hit->{t_name},  $fix * $p_hit->{strand},
                    $downstream_start, $downstream_end
                )
              )
            {
                print STDERR
                  "#### 0 skipping:: bridge over troubled waters p\n";
                next;
            }
        }
        if ( $AGP{$c_ctg} ) {
            my ( $upstream_start, $upstream_end );
            if ( $c_hit->{strand} == 1 ) {
                $upstream_start = $nodes->[$c_node][4];
                $upstream_end   = $c_hit->{t_start};
            }
            else {
                $upstream_start = $c_hit->{t_end};
                $upstream_end   = $nodes->[$c_node][5];
            }
            if (
                query_DMZ(
                    $c_hit->{t_name}, $fix * $c_hit->{strand},
                    $upstream_start,  $upstream_end
                )
              )
            {
                print STDERR
                  "#### 0 skipping:: bridge over troubled waters c\n";
                next;
            }
        }

        # skip to the next hit if it's to the same ctg/chr
        if ( $p_ctg eq $c_ctg ) {
            print STDERR "#### 1 skipping:: same contig\n";
            next;
        }

        # check if this edge bridges connected components that
        # are oriented (anchored to a chromosome)
        if ( not $uf->Compatible( $p_node, $c_node ) ) {
            print STDERR
              "#### 2 skipping:: bridges incompatible contigs ",
              $uf->AGP_range($p_node), " ",
              $uf->AGP_range($c_node), "\n";
            next;
        }

        # need to check if this edges would break the DAG property we need
        # for topological sort.  Instead of a full check, just skip it if
        # both nodes are in the same connected component
        if (    $recursion
            and $uf->Find($p_node) == $uf->Find($c_node) )
        {
            print STDERR "#### 3 skipping:: same connected component\n";
            next;
        }

        # check if orientation is as expected
        if ( $c_hit->{strand} == $nodes->[$c_node][2] ) {
            $this->add_edge( $p_node, $c_node, $rna_name );
        }
        else {
            if ( $this->flip_subgraph($c_node) ) {
                print STDERR "#### 4 flipped c_node $c_node\n";
                $this->add_edge( $p_node, $c_node, $rna_name );
            }
            else {
                if ( $recursion and $this->flip_subgraph($p_node) ) {
                    print STDERR "#### 5 flipped p_node $p_node\n";
                    return $this->add_scaffold_to_graph( flip($hits), 1 );
                }
                else {
                    print STDERR "#### 6 need to break $$hits[0]{q_name}\n";
                    my @remaining_hits = splice( @$hits, $i );
                    return $this->add_scaffold_to_graph( \@remaining_hits, 0 );
                }
            }
        }
    }
}

sub flip_subgraph {
    my $this    = shift;
    my $node_id = shift;

    my $uf    = $this->{uf};
    my $nodes = $this->{nodes};
    my $edges = $this->{edges};

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
    my ( $this, $from, $to, $seq ) = @_;

    my $uf      = $this->{uf};
    my $edges   = $this->{edges};
    my $nodes   = $this->{nodes};
    my $bridges = $this->{bridges};

    # class,space remaining, support
    if ( exists $edges->{$from}{$to} ) {

        # this edge is already there, increment support
        $edges->{$from}{$to}[2]++;

        push @{ $edges->{$from}{$to}[3] }, $seq;
    }
    else {
        if ( exists $edges->{$to}{$from} ) {
            print STDERR "this edge already exists - in the other direction!! ";
            print STDERR "from: ", join( ", ", @{ $nodes->[$from] } );
            print STDERR " to: ", join( ", ", @{ $nodes->[$to] } ), "\n";
        }
        else {
            $edges->{$from}{$to} = [ 'a2b', 1, 1, [$seq] ];
            $uf->Union( $from, $to ) or die "Union failed\n";

            $this->merge_overlaps( $from, $to );

            # check if this edge connects the reference to a de-novo contig
            my ( $chr, $gap_from, $gap_to, $abyss );
            if ( $nodes->[$from][0] eq 'agp' ) {
                $chr   = $nodes->[$from][1];
                $abyss = $nodes->[$to][1];
                if ( $nodes->[$from][2] == 1 )
                {    # alignment to chr is +, so abyss follows node
                    $gap_from = $nodes->[$from][5];
                    $gap_to   = $nodes->[ $from + 1 ][4];
                }
                else {    # gap preceeds node
                    $gap_from = $nodes->[ $from - 1 ][5];
                    $gap_to   = $nodes->[$from][4];
                }
            }
            elsif ( $nodes->[$to][0] eq 'agp' ) {
                $abyss = $nodes->[$from][1];
                $chr   = $nodes->[$to][1];
                if ( $nodes->[$to][2] == -1 ) {    # gap follows node
                    $gap_from = $nodes->[$to][5];
                    $gap_to   = $nodes->[ $to + 1 ][4];
                }
                else {                             # gap preceeds node
                    $gap_from = $nodes->[ $to - 1 ][5];
                    $gap_to   = $nodes->[$to][4];
                }
            }
            else {

                # neither node is from the agp

            }

            # don't bridge before or after the chromosome.
            if ( $chr and $gap_from < $gap_to ) {
                $bridges->{$seq}{$abyss} = [ $chr, $gap_from, $gap_to ];
            }
        }
    }
}

sub merge_overlaps {
    my ( $this, $from, $to ) = @_;
    print STDERR "merge_overlaps($from,$to)\n";
    my $nodes = $this->{nodes};
    my $edges = $this->{edges};
    print STDERR "from node:", join( "\t", @{ $nodes->[$from] } ), "\n";
    print STDERR "to node:",   join( "\t", @{ $nodes->[$to] } ),   "\n";

    my ( $from_seq, $to_seq );
    if ( $nodes->[$from][0] eq 'agp' ) {
        $from_seq = $p{dna_idx}->fetch_substr(
            $nodes->[$from][1],
            $nodes->[$from][4],
            $nodes->[$from][5]
        );
    }
    else {
        $from_seq =
          $p{contig_fidx3}
          ->fetch( $nodes->[$from][1], $nodes->[$from][2] == -1 );
        $from_seq = substr(
            $from_seq,
            $nodes->[$from][4],
            $nodes->[$from][5] - $nodes->[$from][4]
        );
    }
    if ( $nodes->[$to][0] eq 'agp' ) {
        $to_seq =
          $p{dna_idx}->fetch_substr( $nodes->[$to][1], $nodes->[$to][4],
            $nodes->[$to][5] );
    }
    else {
        $to_seq =
          $p{contig_fidx3}->fetch( $nodes->[$to][1], $nodes->[$to][2] == -1 );
        $to_seq = substr(
            $to_seq,
            $nodes->[$to][4],
            $nodes->[$to][5] - $nodes->[$to][4]
        );
    }

    my $hits = $aligner->blat2seqs( $from_seq, $to_seq );
    if ($hits) {
        for my $hit (@$hits) {
            next if ( identity($hit) < 0.99 );
            if (    $hit->{q_end} == $hit->{q_size}
                and $hit->{t_start} == 0 )
            {

                # adjust abyss contig to avoid the overlap
                if ( $nodes->[$from][0] eq 'abyss' ) {
                    $nodes->[$from][5] -= $hit->{q_end} - $hit->{q_start};
                    $nodes->[$from][4] <= $nodes->[$from][5]
                      or die "lost from node "
                      . join( ", ", @{ $nodes->[$from] } ) . "\n";
                    $edges->{$from}{$to}[0] = "overlap";
                    $this->{overlap}{$from}{$to} = 1;
                    print STDERR "overlap: $from -> $to\n";
                }
                elsif ( $nodes->[$to][0] eq 'abyss' ) {
                    $nodes->[$to][4] += $hit->{q_end} - $hit->{q_start};
                    $nodes->[$to][4] <= $nodes->[$to][5]
                      or die "lost to node "
                      . join( ", ", @{ $nodes->[$to] } ) . "\n";
                    $edges->{$from}{$to}[0] = "overlap";
                    $this->{overlap}{$from}{$to} = 1;
                    print STDERR "overlap: $from -> $to\n";
                }
                last;
            }
        }
    }
}

sub reverse_complement {
    my ( $this, $hitsref ) = @_;
    my @rc;
    for my $hit (@$hitsref) {
        $hit->{strand} = $hit->{strand} eq '+' ? '-' : '+';
        my $revQstart = $hit->{q_start};
        my $revQend   = $hit->{q_end};
        $hit->{q_start} = $hit->{q_size} - $revQend;
        $hit->{q_end}   = $hit->{q_size} - $revQstart;

        # thanks to the PSL format designers for making it
        # so qStarts, tStarts, and blockSizes don't have to be changed
        unshift @rc, $hit;
    }
    return \@rc;
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

sub place_scaffolds {
    my $this = shift;

    my $uf     = $this->{uf};
    my $nodes  = $this->{nodes};
    my $bridge = $this->{bridges};

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
            if ( $gpos{$seq} ) {
                my ( $chr, $from, $to, $direction, $fixed ) = @{ $gpos{$seq} };
                my $syn_support = 0;
                if ( $synteny_map{$seq}{$chr} ) {
                    my $syn_from = $synteny_map{$seq}{$chr}[0] - $leeway;
                    my $syn_to   = $synteny_map{$seq}{$chr}[1] + $leeway;
                    if ( $syn_from <= $to and $syn_to >= $from ) {
                        $syn_support = 1;
                        $direction ||= $synteny_map{$seq}{$chr}[2];
                        print STDERR
"GBS $seq has syn_support $chr $from $to $direction\n";
                    }
                }
                push @GBS_intervals,     [ $chr, $from, $to, 0 ];
                push @syn_GBS_intervals, [ $chr, $from, $to, $direction ]
                  if $syn_support;
            }
            if ( $bridge->{$seq} ) {
                for my $contig ( keys %{ $bridge->{$seq} } ) {
                    if ( $contigs{$contig} ) {
                        my ( $chr, $from, $to ) = @{ $bridge->{$seq}{$contig} };
                        my $syn_support = 0;
                        if ( $synteny_map{$seq}{$chr} ) {
                            my $syn_from =
                              $synteny_map{$seq}{$chr}[0] - $leeway;
                            my $syn_to = $synteny_map{$seq}{$chr}[1] + $leeway;
                            if ( $syn_from <= $to and $syn_to >= $from ) {
                                $syn_support = 1;
                            }
                        }
                        push @bridge_gaps, [ $chr, $from, $to, 1 ];
                        if ($syn_support) {
                            print STDERR
"bridge $seq -> $contig cDNA has syn_support $chr $from $to\n";
                            push @syn_bridge_gaps, [ $chr, $from, $to, 1 ];
                        }
                        elsif ( $synteny_map{$contig}{$chr} ) {
                            my $syn_from =
                              $synteny_map{$contig}{$chr}[0] - $leeway;
                            my $syn_to =
                              $synteny_map{$contig}{$chr}[1] + $leeway;
                            if ( $syn_from <= $to and $syn_to >= $from ) {
                                print STDERR
"bridge $seq -> $contig contig has syn_support $chr $from $to\n";
                                push @syn_bridge_gaps, [ $chr, $from, $to, 1 ];
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
            print STDERR
              join( "\t", "TABLE", $scaffold, $n_GBS, $n_bridges ),
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
                    $uf->{agp_range}{$root} ||= spanner($bridge_clusters);
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
    my @span =
      ( $interval->[0], $interval->[1], $interval->[2], $interval->[4], 1 );
    for $interval (@sorted) {
        my ( $chr, $from, $to, $score, $strand ) = @$interval;
        last if ( $score < $span[3] );
        $chr eq $span[0]
          or return [];
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
        my ( $intervals, $max_depth, $strand ) = @$cluster;
        my ( $chr, $min, $max ) =
          ( $intervals->[0][0], $intervals->[-1][2], $intervals->[0][1] );
        for my $interval (@$intervals) {
            if ( $interval->[3] == $max_depth ) {
                $min = $interval->[1] if $interval->[1] < $min;
                $max = $interval->[2] if $interval->[2] > $max;
            }
        }
        push @tops, [ $chr, $min, $max, $max_depth, $strand ];
    }
    return \@tops;
}

sub cluster_votes {
    my $votes = shift;

    my %cluster;
    my @clusters;
    for my $pos ( sort { $a->[0] cmp $b->[0] or $a->[1] <=> $b->[1] } @$votes )
    {
        my ( $seqid, $start, $end, $strand ) = @$pos;
        $start--;    # because we expect half open intervals
        if (    %cluster
            and $seqid eq $cluster{SEQID}
            and $start <= $cluster{END}
            and $strand * $cluster{STRAND} != -1 )
        {            # overlaps with previous cluster
            $cluster{DEPTH}{$start} =
              exists $cluster{DEPTH}{$start}
              ? $cluster{DEPTH}{$start} + 1
              : 1;
            $cluster{DEPTH}{$end} =
              exists $cluster{DEPTH}{$end}
              ? $cluster{DEPTH}{$end} - 1
              : -1;
            if ( $end > $cluster{END} ) {
                $cluster{END} = $end;
            }
            $cluster{STRAND} ||= $strand;
        }
        else {

            # output previous cluster
            push @clusters, score_cluster( \%cluster ) if %cluster;

            # create a new cluster
            %cluster = (
                SEQID  => $seqid,
                'END'  => $end,
                STRAND => $strand,
                DEPTH  => { $start => 1, $end => -1 }
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
    return [ \@intervals, $max_depth, $cluster->{STRAND} ];
}

sub output_agp {
    my $this     = shift;
    my $uf       = $this->{uf};
    my $nodes    = $this->{nodes};
    my $edges    = $this->{edges};
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

            # sort the edges by class ("overlap" gt "a2b")
            my @to =
              sort { $edges->{$n}{$b}[0] cmp $edges->{$n}{$a}[0] }
              keys %{ $edges->{$n} };
            $edges->{$n} = {};
            for my $m (@to) {
                delete $parent{$m}{$n};

                # break other edges so overlapping nodes are adjacent
                if ( $this->{overlap}{$n}{$m} ) {
                    for my $p ( keys %{ $parent{$m} } ) {
                        delete $edges->{$p}{$m};
                        delete $parent{$m}{$p};
                    }
                }
                if ( not keys %{ $parent{$m} } ) {
                    push @S, $m;
                }
            }
        }

        # cut agp nodes out of @L
        my @lists;
        my $n_lists = 0;
        if (0) {
            for ( my $i = 0 ; $i < @L ; $i++ ) {
                if ( $nodes->[ $L[$i] ][0] eq 'agp' ) {
                    $n_lists++ if $i;
                }
                else {
                    push @{ $lists[$n_lists] }, $L[$i];
                }
            }
        }
        else {
            $lists[0] = \@L;
        }

        for ( my $i = 0 ; $i < @lists ; $i++ ) {
            $scaffold++;
            my $part = 0;
            my $pos  = 1;
            print STDERR join( " -> ", "TS:", @{ $lists[$i] } ), "\n";
            my $j       = 0;
            my $n_nodes = @{ $lists[$i] };
            for ( my $j = 0 ; $j < $n_nodes ; $j++ ) {
                my $node = $lists[$i][$j];
                $part++;
                my ( $class, $name, $dir, $fl, $from, $to, $rna_support ) =
                  @{ $nodes->[$node] };
                my $len = $to - $from;
                my $seq;
                if ( $class eq 'abyss' ) {
                    $seq = $p{contig_fidx3}->fetch( $name, $dir != 1 );
                    $seq
                      or die "can't find $name (dir= $dir) in $p{scaffolds}\n";
                    length($seq) == $len
                      or $seq = substr( $seq, $from, $len );
                }
                else {

  #                    $seq = $p{dna_idx}->fetch_substr( $name, $from, $to, 0 );
                    $seq = "suppressed";
                }
                print join( "\t",
                    "GeneScaffold_" . $scaffold, $pos,
                    $pos + $len - 1,             $part,
                    'D',                         $name,
                    $from + 1,                   $to,
                    $dir == 1 ? '+' : '-', $uf->AGP_range($node),
                    $seq ),
                  "\n";
                $pos += $len;

                if ( $j < $n_nodes - 1 ) {
                    my $k = $j + 1;

                    # no gaps between overlapping nodes
                    exists $this->{overlap}{$node}
                      and exists $this->{overlap}{$node}{ $lists[$i][$k] }
                      and next;
                    $part++;
                    print join( "\t",
                        "GeneScaffold_" . $scaffold,
                        $pos, $pos + 49, $part, 'N', '50', 'fragment', 'no', '',
                        'NA' ),
                      "\n";
                    $pos += 50;
                }
            }
        }
    }
}

sub output_graph {
    my $this     = shift;
    my $outdir   = shift;
    my $uf       = $this->{uf};
    my $nodes    = $this->{nodes};
    my $edges    = $this->{edges};
    my $scaffold = 0;
    for my $root ( $uf->Roots() ) {
        my @chars = split //, $root;
        my $size = scalar @{ $uf->{neighbors}{$root} };
        next if ( $size == 1 and $nodes->[$root][0] eq 'agp' );
        $scaffold++;

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

1;
