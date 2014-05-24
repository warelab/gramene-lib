#!/usr/bin/perl -w
use strict;

my @PSL = (
    'match',       'mismatch',    'rep_match',   'Ns',
    'q_gap_count', 'q_gap_bases', 't_gap_count', 't_gap_bases',
    'strand',      'q_name',      'q_size',      'q_start',
    'q_end',       't_name',      't_size',      't_start',
    't_end',       'block_count', 'blockSizes',  'qStarts',
    'tStarts'
);

my ( $gbs_file, $syn_file, $psl_file ) = @ARGV;
open( my $psl, "<", $psl_file )
  or die "failed to open $psl_file for reading : $!\n";
my ( %hits, %cDNAhits );
while (<$psl>) {
    chomp;
    my @x = split /\t/, $_;
    my %hit;
    for ( my $i = 0 ; $i < @x ; $i++ ) {
        $hit{ $PSL[$i] } = $x[$i];
    }
    push @{ $hits{ $hit{q_name} } }, \%hit;
    push @{ $cDNAhits{ $hit{t_name} }{ $hit{q_name} } }, \%hit
      if $hit{t_name} !~ /^ch/;
}
close $psl;

my $gbs = load_gbs($gbs_file);
my $syn = load_syn($syn_file);

# build up a black-list of cDNA-contig pairs that are bad
my %bad;
for my $contig ( keys %cDNAhits ) {
    my @cDNAs = keys %{ $cDNAhits{$contig} };
    if ( @cDNAs > 1 ) {
        print STDERR "$contig is hit by ", scalar @cDNAs, " cDNAs\n";

        # does this contig have GBS or SYN?
        # if so, it would already be consistent with the cDNAs
        #        although there could still be inconsistencies
        my @contig_gpos = contig_gpos($contig);
        for my $pos (@contig_gpos) {
            print STDERR "contig_gpos: ", join( ':', @$pos ), "\n";
        }

        # score the hits by coverage*identity
        my %scores;
        for ( my $i = 0 ; $i < @cDNAs ; $i++ ) {

            # lookup gpos for this cDNA
            my @cDNA_gpos = cDNA_gpos( $cDNAs[$i] );
            for my $pos (@cDNA_gpos) {
                print STDERR "cDNA_gpos: ", join( ":", @$pos ), "\n";
            }

            # check if it is consistent with the contig_gpos
            my $consistent = consistent_mappings( \@contig_gpos, \@cDNA_gpos );

            $scores{$i} = 0;
            for my $hit ( @{ $cDNAhits{$contig}{ $cDNAs[$i] } } ) {
                $scores{$i} += hitlen($hit) * identity($hit);
            }
            print STDERR
              "$cDNAs[$i]: $scores{$i} $consistent $#contig_gpos $#cDNA_gpos\n";
        }
        my @sorted     = sort { $scores{$b} <=> $scores{$a} } keys %scores;
        my $best       = $sorted[0];
        my $best_score = $scores{$best};
        for my $i (@sorted) {
            my @cDNA_gpos = cDNA_gpos( $cDNAs[$i] );
            if (    @contig_gpos
                and @cDNA_gpos
                and not consistent_mappings( \@contig_gpos, \@cDNA_gpos ) )
            {
                $bad{ $cDNAs[$i] }{$contig} = 1;
            }
            elsif ( $scores{$i} < 0.3 * $best_score ) {
                $bad{ $cDNAs[$i] }{$contig} = 2;
            }
            else {
                if (@contig_gpos) {
                    @contig_gpos =
                      intersect_mappings( \@contig_gpos, \@cDNA_gpos );
                }
                else {
                    @contig_gpos = @cDNA_gpos;
                }
            }
        }
    }
}
for my $cDNA ( keys %hits ) {
    for my $hit ( @{ $hits{$cDNA} } ) {
        if ( $bad{$cDNA}{ $hit->{t_name} } ) {
            print "skip $bad{$cDNA}{$$hit{t_name}}:";
        }
        print join( "\t", map { $hit->{$_} } @PSL ), "\n";
    }
}
exit;

sub load_gbs {
    my $file_name = shift;
    open( my $fh, "<", $file_name )
      or die "failed to open $file_name for reading : $!\n";
    my %res;
    while (<$fh>) {
        chomp;
        my ( $id, $chr, $start, $end, $mean ) = split /\t/, $_;
        $res{$id} = [ "chr$chr", $start, $end ];
    }
    close $fh;
    return \%res;
}

sub load_syn {
    my $file_name = shift;
    open( my $fh, "<", $file_name )
      or die "failed to open $file_name for reading : $!\n";
    my %res;
    while (<$fh>) {
        chomp;
        my ( $id, $syn_gene, $subgenome, $chr, $from, $to, $method, @etc ) =
          split /\t/, $_;
        $method = "non-direct" if $method ne "direct";
        $res{$id}{"chr$chr"} = [ $from, $to, $method ];
    }
    close $fh;
    return \%res;
}

sub cDNA_gpos {
    my $cDNA = shift;

    # check if the cDNA hits the reference
    my @range = ();
    for my $hit ( @{ $hits{$cDNA} } ) {
        my $ctg = $hit->{t_name};
        next if $ctg =~ m/^\d+$/;
        $range[0] = $hit->{t_name};
        $range[1] ||= $hit->{t_start};
        $range[2] ||= $hit->{t_end};
        $range[1] = $hit->{t_start} if $hit->{t_start} < $range[1];
        $range[2] = $hit->{t_end}   if $hit->{t_end} > $range[1];
    }
    if ( @range == 3 ) {
        return ( \@range );
    }

    # no alignments to reference
    # check for GBS mapping
    my @mappings;
    if ( exists $gbs->{$cDNA} ) {
        push @mappings, $gbs->{$cDNA};
    }
    if ( exists $syn->{$cDNA} ) {
        for my $chr ( keys %{ $syn->{$cDNA} } ) {
            my ( $from, $to, $direct ) = @{ $syn->{$cDNA}{$chr} };
            push @mappings, [ $chr, $from, $to ];
        }
    }
    return @mappings;
}

sub contig_gpos {
    my $contig = shift;
    my @mappings;
    if ( exists $gbs->{$contig} ) {
        push @mappings, $gbs->{$contig};
    }
    if ( exists $syn->{$contig} ) {
        for my $chr ( keys %{ $syn->{$contig} } ) {
            my ( $from, $to, $direct ) = @{ $syn->{$contig}{$chr} };
            push @mappings, [ $chr, $from, $to ];
        }
    }
    return @mappings;
}

sub intersect_mappings {
    my ( $contig_gpos, $cDNA_gpos ) = @_;
    for my $contig_pos (@$contig_gpos) {
        for my $cDNA_pos (@$cDNA_gpos) {
            my @overlap = intersect_ranges( $contig_pos, $cDNA_pos );
            @overlap and return ( \@overlap );
            @overlap =
              intersect_ranges( $contig_pos,
                expand_range( $cDNA_pos, 1000000 ) );
            @overlap and return ( \@overlap );
            @overlap =
              intersect_ranges( $contig_pos,
                expand_range( $cDNA_pos, 5000000 ) );
            @overlap and return ( \@overlap );
            @overlap =
              intersect_ranges( $contig_pos,
                expand_range( $cDNA_pos, 10000000 ) );
            @overlap and return ( \@overlap );
        }
    }
    return ();
}

sub consistent_mappings {
    my ( $contig_gpos, $cDNA_gpos ) = @_;

    for my $contig_pos (@$contig_gpos) {
        for my $cDNA_pos (@$cDNA_gpos) {
            my @overlap =
              intersect_ranges( $contig_pos,
                expand_range( $cDNA_pos, 5000000 ) );
            @overlap and return 1;
        }
    }
    return 0;
}

sub expand_range {
    my ( $range, $size ) = @_;
    my @expanded = @$range;
    $expanded[1] -= $size;
    $expanded[2] += $size;
    return \@expanded;
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
        my @x =
          sort { $a <=> $b } ( $r1->[1], $r1->[2], $r2->[1], $r2->[2] );
        return ( $r1->[0], $x[1], $x[2] );
    }
    return ();
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
