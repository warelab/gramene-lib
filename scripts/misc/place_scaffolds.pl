#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my %args;
GetOptions( \%args, 'scaffolds=s@', 'agp=s', 'wgs=s' );

my %WGS;
load_WGS( $args{wgs} );
my %AGP;
load_AGP( $args{agp} );
for my $fname ( @{ $args{scaffolds} } ) {
    if ( $fname =~ m/^scaffolds_([0-9][0-9]I*)\/scaffolds.agp/ ) {
        my $k = $1;
        open( my $fh, "<", $fname )
          or die "failed to open scaffold file $fname for reading : $!\n";
        do_scaffolds( $k, $fh );
        close $fh;
    }
    else {
        die "file name $fname doesn't match\n";
    }
}

exit;

sub load_AGP {
    my $agp_file = shift;
    print STDERR "load_AGP($agp_file)";
    if ( $agp_file =~ m/\.gz$/ ) {
        $agp_file = "gzip -cd $agp_file |";
    }
    open( my $agpfh, $agp_file ) or die "failed to open $agp_file: $!\n";
    while (<$agpfh>) {
        chomp;
        my ( $chr, $from, $to, $i, $DN, $glen, $gtype, $yn, @etc ) = split /\t/,
          $_;
        next if ( $DN ne 'N' );
        $from--;
        $chr = "chr$chr" if $chr =~ m/^\d+$/;

        # skip gaps that are spanned by WGS genes
        if ( not $WGS{$chr} ) {
            print STDERR "no WGS genes on $chr\n";
            next;
        }
        my $nearest_gene =
          nearest_interval( $WGS{$chr}, int( ( $from + $to ) / 2 ) );
        next
          if (  $WGS{$chr}[$nearest_gene][0] < $from
            and $WGS{$chr}[$nearest_gene][1] > $to );
        if ( exists $AGP{$gtype}{$chr} ) {
            push @{ $AGP{$gtype}{$chr} }, [ $from, $to ];
        }
        else {
            $AGP{$gtype}{$chr} = [ [ $from, $to ] ];
        }
    }
    close $agpfh;
    print STDERR " done\n";

}

sub load_WGS {
    my $WGS_genes = shift;
    print STDERR "load_WGS($WGS_genes)";
    open( my $WGSfh, "<", $WGS_genes ) or die "failed to open $WGS_genes: $!\n";
    while (<$WGSfh>) {
        chomp;
        my ( $chr, $from, $to, $strand ) = split /\t/, $_;
        $chr = "chr$chr" if $chr =~ m/^\d+$/;
        if ( exists $WGS{$chr} ) {
            push @{ $WGS{$chr} }, [ $from, $to ];
        }
        else {
            $WGS{$chr} = [ [ $from, $to ] ];
        }
    }
    close $WGSfh;

    # sort intervals
    for my $chr ( keys %WGS ) {
        my @intervals =
          sort { $a->[0] <=> $b->[0] } @{ $WGS{$chr} };
        $WGS{$chr} = \@intervals;
    }

    # merge overlaps
    for my $chr ( keys %WGS ) {
        my @clusters;
        push @clusters, shift @{ $WGS{$chr} };
        for my $interval ( @{ $WGS{$chr} } ) {
            if ( $interval->[0] <= $clusters[-1][1] ) {
                if ( $interval->[1] > $clusters[-1][1] ) {
                    $clusters[-1][1] = $interval->[1];
                }
            }
            else {
                push @clusters, $interval;
            }
        }
        $WGS{$chr} = \@clusters;
    }

    print STDERR " done\n";
}

sub do_scaffolds {
    my ( $k, $fh ) = @_;
    my $scaffold_num = 0;
    my @scaffold;
    while (<$fh>) {
        /^GeneScaffold_/ or next;
        chomp;
        s/GeneScaffold_//;
        my @cols = split /\t/, $_;
        if ( $cols[0] > $scaffold_num ) {
            process_scaffold( \@scaffold ) if @scaffold;
            @scaffold     = ();
            $scaffold_num = $cols[0];
        }
        $cols[0] = "k${k}_$cols[0]";
        if ( $cols[4] eq 'D' ) {
            $cols[10] = 'noseq';
            $cols[5] = "k${k}_$cols[5]" if $cols[5] =~ m/^\d+$/;
        }
        push @scaffold, \@cols;
    }
    process_scaffold( \@scaffold ) if @scaffold;
}

sub process_scaffold {
    my $scaffold = shift;
    if ( $scaffold->[0][9] eq '-' ) {

        # dump it in the unknown chr
        for my $part (@$scaffold) {
            print join( "\t", @$part ), "\n";
        }
        return;
    }

    my ( $chr, $from, $to, $strand, $fixed ) =
      $scaffold->[0][9] =~ m/(\w+):(\d+)-(\d+):(-?\d):(\d)/;

    my $bridged = 0;
    for my $part (@$scaffold) {
        if ( $part->[5] =~ m/ch/ ) {
            $bridged = 1;
            last;
        }
    }

    if ( not $bridged ) {
        my $center = int( ( $from + $to ) / 2 );
        my $clone_gap    = nearest_interval( $AGP{clone}{$chr},    $center );
        my $contig_gap   = nearest_interval( $AGP{contig}{$chr},   $center );
        my $fragment_gap = nearest_interval( $AGP{fragment}{$chr}, $center );
        my $clone_gap_dist =
          distance( @{ $AGP{clone}{$chr}[$clone_gap] }, $from, $to );
        my $contig_gap_dist =
          distance( @{ $AGP{contig}{$chr}[$contig_gap] }, $from, $to );
        my $fragment_gap_dist =
          distance( @{ $AGP{fragment}{$chr}[$fragment_gap] }, $from, $to );
        if ( $clone_gap_dist < 10000 or $contig_gap_dist < 10000 ) {

            if ( $contig_gap_dist < $clone_gap_dist ) {
                ( $from, $to ) = @{ $AGP{contig}{$chr}[$contig_gap] };
            }
            else {
                ( $from, $to ) = @{ $AGP{clone}{$chr}[$clone_gap] };
            }
        }
        elsif ( $fragment_gap_dist < 10000 ) {
            ( $from, $to ) = @{ $AGP{fragment}{$chr}[$fragment_gap] };
        }
        elsif ( $clone_gap_dist < 100000 or $contig_gap_dist < 100000 ) {
            if ( $contig_gap_dist < $clone_gap_dist ) {
                ( $from, $to ) = @{ $AGP{contig}{$chr}[$contig_gap] };
            }
            else {
                ( $from, $to ) = @{ $AGP{clone}{$chr}[$clone_gap] };
            }
        }
        elsif ( $fragment_gap_dist < 100000 ) {
            ( $from, $to ) = @{ $AGP{fragment}{$chr}[$fragment_gap] };
        }
        else {
            $from = -999;    # send it to the unknown chr
        }
    }
    my $range = ( $from == -999 ) ? '-' : "$chr:${from}-$to:$strand";
    for my $part (@$scaffold) {
        $part->[9] = $range;
        print join( "\t", @$part ), "\n";
    }
}

sub distance {
    my ( $s, $e, $ss, $ee ) = @_;
    if ( $e < $ss ) {
        return $ss - $e;
    }
    if ( $ee < $s ) {
        return $s - $ee;
    }
    return 0;
}

sub nearest_interval {
    my ( $arr, $pos ) = @_;
    my $last = @$arr - 1;
    my $res = bsearch( $pos, $arr, 0, $last );

    # check if $arr->[$res] is indeed the nearest interval to $pos;
    my ( $from, $to ) = @{ $arr->[$res] };
    if ( $pos < $from and $res > 0 ) {
        my $d1 = $from - $pos;
        my $d2 = $pos - $arr->[ $res - 1 ][1];
        $d2 < $d1 and return $res - 1;
    }
    elsif ( $pos > $to and $res < $last ) {
        my $d1 = $pos - $to;
        my $d2 = $arr->[ $res + 1 ][0] - $pos;
        $d2 < $d1 and return $res + 1;
    }
    return $res;
}

sub bsearch {
    my ( $x, $arr, $a, $b ) = @_;
    if ( $a == $b ) {
        return $a;
    }
    my $mid = int( ( $a + $b ) / 2 );
    my ( $from, $to ) = @{ $arr->[$mid] };
    if ( $x <= $to and $x >= $from ) {
        return $mid;
    }
    if ( $x < $from ) {
        return bsearch( $x, $arr, $a, $mid );
    }
    if ( $x > $to ) {
        return bsearch( $x, $arr, $mid + 1, $b );
    }
}
