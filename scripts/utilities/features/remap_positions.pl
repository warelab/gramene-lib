#!/usr/bin/perl -w
use strict;

my $map_file = shift @ARGV;
my $sr_col = shift @ARGV;
my $start_col = shift @ARGV;
my $end_col = shift @ARGV;
my $strand_col = shift @ARGV;

$map_file
  or die
"usage: $1 <map file> <seq region column> <start column> <end column> <strand column>\n";

my $map = load_map($map_file);

while (<>) {
    if (/^#/ or !/\S+/ or !/^scaffold/) {
#	print $_;
	next;
    }
    chomp;
    my @cols = split /\t/, $_;
    my $bad = 1;
    my ( $start_chr, $start_pos, $start_ori ) =
      remap( $map, $cols[$sr_col], $cols[$start_col] );
    if ($start_chr) {
        if ( $end_col >= 0 ) {
            my ( $end_chr, $end_pos, $end_ori ) =
              remap( $map, $cols[$sr_col], $cols[$end_col] );
            if ($end_chr) {
                if ( $start_chr eq $end_chr and $start_ori == $end_ori ) {

                    # both points map to the same chr and strand
                    if ( $end_ori == -1 ) {
                        $cols[$end_col]   = $start_pos;
                        $cols[$start_col] = $end_pos;
                    }
                    else {
                        $cols[$start_col] = $start_pos;
                        $cols[$end_col]   = $end_pos;
                    }
                    $bad = 0;
                }
            }
            else {
                print STDERR
                  "chr: $cols[$sr_col] end: $cols[$end_col] failed\n";
            }
        }
        else {
            $cols[$start_col] = $start_pos;
            $bad = 0;
        }
    }
    else {
        print STDERR "chr: $cols[$sr_col] start: $cols[$start_col] failed\n";
    }

    if ($bad) {
        print STDERR "FAILED: $_\n";
    }
    else {
        $cols[$sr_col] = $start_chr;
        if ( $strand_col >= 0 ) {
            if ($cols[$strand_col] eq '+') {
              if ($start_ori == -1) {
                $cols[$strand_col] = '-';
              }
            }
            elsif ($cols[$strand_col] eq '-') {
              if ($start_ori == -1) {
                $cols[$strand_col] = '+';
              }
            }
            elsif ($cols[$strand_col] =~ m/^-?\d$/) {
              $cols[$strand_col] *= $start_ori;
            }
        }
        print join( "\t", @cols ), "\n";
    }
}

exit;

sub load_map {
    my $map_file = shift;
    open( my $mapfh, "<", $map_file )
      or die "failed to open $map_file for reading : $!\n";
    my %intervals;
    while (<$mapfh>) {
        chomp;
        my ( $chr, $from, $to, $newchr, $newfrom, $newto, $ori ) = split /\t/,
          $_;
        push @{ $intervals{$chr} },
          [ $from, $to, $newchr, $newfrom, $newto, $ori ];
    }
    close $mapfh;
    return \%intervals;
}

sub compare_to_interval {
    my ( $interval, $value ) = @_;
    if ( $value < $$interval[0] ) {
        return -1;
    }
    if ( $value > $$interval[1] ) {
        return 1;
    }
    return 0;
}

sub bsearch_intervals {
    my ( $list, $value, $a, $b ) = @_;
    my $mid = $a + int( ( $b - $a ) / 2 );
    my $check = compare_to_interval( $list->[$mid], $value );
    if ( $check == 0 ) {
        return $mid;
    }
    if ( $check < 0 ) {
        if ( $mid == $a ) {
            return -1;
        }
        return bsearch_intervals( $list, $value, $a, $mid - 1 );
    }
    if ( $check > 0 ) {
        if ( $mid == $b ) {
            return -1;
        }
        return bsearch_intervals( $list, $value, $mid + 1, $b );
    }
}

# there are no comments in this code....
sub remap {
    my ( $map, $chr, $pos ) = @_;
    exists $map->{$chr} or return ( undef, undef, undef );
    my $i = bsearch_intervals( $map->{$chr}, $pos, 0, @{ $map->{$chr} } - 1 );
    $i >= 0 or return ( undef, undef, undef );

    my ( $start, $end, $new_chr, $new_start, $new_end, $ori ) =
      @{ $map->{$chr}[$i] };
    my $new_pos;
    my $offset = $pos - $start;
    if ( $ori == 1 ) {
        $new_pos = $new_start + $offset;
    }
    else {
        $new_pos = $new_end - $offset;
    }
    return ( $new_chr, $new_pos, $ori );
}
