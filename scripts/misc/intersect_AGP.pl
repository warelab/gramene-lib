#!/usr/bin/perl -w
use strict;

my $agp_file = shift @ARGV;

# read AGP file
my $AGP = read_AGP($agp_file);

while (<>) {
    if ( my ( $scaffold, $chr, $from, $to ) = /(K\S+)\t(chr.+):(\d+)-(\d+)/ ) {

        # lookup the gaps in the AGP that overlap the interval [$chr,$from,$to]
        my $gaps = find_overlaps( $from, $to, $AGP->{$chr} );
        if (@$gaps) {

            # output the options.
            for my $gap (@$gaps) {
                print join( "\t", $scaffold, $chr, $from, $to, @$gap ), "\n";
            }
        }
        else {
            print join( "\t", $scaffold, $chr, $from, $to, "no gaps overlap" ),
              "\n";
        }
    }
    else {
        die "failed to parse line: $_";
    }
}

exit;

sub read_AGP {
    my $agp_file = shift;
    my %AGP;
    if ( $agp_file =~ m/\.gz$/ ) {
        $agp_file = "gzip -cd $agp_file |";
    }
    open( IN, $agp_file ) or die "failed to open $agp_file: $!\n";
    while (<IN>) {
        chomp;
        my ( $chr, $from, $to, $i, $DN, $gap_len, $gap_type, $linkage, @etc ) =
          split /\t/, $_;
        $from--;
        $chr = "chr$chr" if $chr =~ m/^\d+$/;
        if ( $DN eq 'N' ) {
            if ( $AGP{$chr} and $AGP{$chr}[-1][-1] + 1 == $from ) {
                $AGP{$chr}[-1][-1] = $to;
            }
            else {
                push @{ $AGP{$chr} },
                  [ $gap_type, $gap_len, $linkage, $from, $to ];
            }
        }
    }
    close IN;
    return \%AGP;
}

sub find_overlaps {
    my ( $from, $to, $gaps ) = @_;
    my $n_gaps = @$gaps;
    my $first = find_next_gap( $from, $gaps, 0, $n_gaps - 1 );

    defined $first or return [];
    my @overlaps;
    for ( my $i = $first ; $i < $n_gaps ; $i++ ) {
        last if ( $gaps->[$i][-2] > $to );
        push @overlaps, $gaps->[$i];
    }
    return \@overlaps;
}

sub check_interval {
    my ( $n, $from, $to ) = @_;
    if ( defined $from and $n < $from ) { return -1; }
    if ( defined $to   and $n > $to )   { return 1; }
    return 0;
}

sub find_next_gap {
    my ( $n, $intervals, $a, $b ) = @_;
    if ( $a >= $b ) {
        my $check =
          check_interval( $n, $intervals->[$a][3], $intervals->[$a][4] );
        return $check > 0 ? $a+1 : $a;
    }
    my $mid = int( ( $a + $b ) / 2 );
    my $check =
      check_interval( $n, $intervals->[$mid][3], $intervals->[$mid][4] );
    if ( $check == 1 ) {
        return find_next_gap( $n, $intervals, $mid + 1, $b );
    }
    if ( $check == -1 ) {
        $a == $mid and return undef;
        return find_next_gap( $n, $intervals, $a, $mid - 1 );
    }
    return $mid;
}
