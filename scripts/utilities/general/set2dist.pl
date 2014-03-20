#!/usr/bin/env perl
use warnings;
use strict;
use POSIX;

# convert a set of numbers to a distribution

my $bin = shift @ARGV;
my $col = shift @ARGV;
$bin
  or die "usage: $0 <bin size> <column number (0 based)> <table (on STDIN)>\n";
my $delim = "\t";
my $n     = 0;
my $sum   = 0;
my $min   = 1000000000;
my $max   = -999999999;
my %dist;

while (<>) {
    chomp;
    my @x = split /$delim/, $_;
    my $val = $x[$col];
    is_numeric($val) or next;
    $sum += $val;
    $min = $val if ( $val < $min );
    $max = $val if ( $val > $max );
    my $obin = int( $val / $bin );
    $dist{$obin}++;
    $n++;
}

my $nover2   = $n / 2;
my $half_ass = $sum / 2;
my $mean     = int( 1000 * $sum / $n + 0.5 ) / 1000;
my $sum2     = 0;

my $minbin = $bin * floor( $min / $bin );
my %cumdist;
while ( my ( $obin, $tally ) = each %dist ) {
    $sum2 += $tally * ( $obin * $bin - $mean )**2;
}
my $stdev = int( 1000 * sqrt( $sum2 / $n ) + 0.5 ) / 1000;

my $N50_sum = 0;
my $N50     = 0;
my ( $mode_height, $mode_bin ) = ( 0, 0 );
my $median_bin = 0;
my $iter       = 0;
my $previ;
my @bins = sort { $a <=> $b } keys %dist;
for my $i (@bins) {
    $iter++;

    if ( $N50_sum < $half_ass ) {
        $N50 = $minbin + $i * $bin + floor( $bin / 2 );
        $N50_sum += $dist{$i} * $N50;
    }

    $cumdist{$i} = $dist{$i};
    if ( $iter > 1 ) {
        $cumdist{$i} += $cumdist{$previ};
    }

    if ( $cumdist{$i} < $nover2 ) {
        $median_bin = $i;
    }

    if ( $dist{$i} > $mode_height ) {
        $mode_height = $dist{$i};
        $mode_bin    = $i;
    }

    $previ = $i;
}

my $mode   = $mode_bin * $bin;
my $median = $median_bin * $bin;

#print "# ", join ("\t",qw(N mean stdev median mode min max N50(bin))),"\n";
#print "# ", join ("\t",($n,$mean,$stdev,$median, $mode,$min,$max,$N50)),"\n";

print qq{# N\t$n
# mean\t$mean
# stdev\t$stdev
# median\t$median
# mode\t$mode
# min\t$min
# max\t$max
# N50\t$N50
# sum\t$sum
};

print "\n#", join( "\t", qw(bin raw_dist norm_dist cumulative_dist) ), "\n";
for my $i (@bins) {
    print join( "\t",
        $i * $bin, $dist{$i},
        int( 1000 * $dist{$i} / $n ) / 1000,
        int( 1000 * $cumdist{$i} / $n ) / 1000 ),
      "\n";
}

sub getnum {
    my $str = shift;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $! = 0;
    my ( $num, $unparsed ) = strtod($str);
    if ( ( $str eq '' ) || ( $unparsed != 0 ) || $! ) {
        return undef;
    }
    else {
        return $num;
    }
}

sub is_numeric { defined getnum( $_[0] ) }
