#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $mapfile = shift @ARGV;
my $chridx = shift @ARGV;
my $posidx = shift @ARGV;

my $map = loadMap($mapfile);

while (<>) {
    chomp;
    my @x = split /\t/, $_;
    if (exists $map->{$x[$chridx]}) {
        my @locations = remap($map->{$x[$chridx]}, $x[$posidx]);
        for my $loc (@locations) {
            $x[$chridx] = $loc->[0];
            $x[$posidx] = $loc->[1];
            print join ("\t", @x,@{$loc->[2]}),"\n";
        }
    }
    else {
        die "chromosome $x[$chridx] not in map $mapfile\n";
    }
}

exit;

sub loadMap {
	my $file = shift;
    open (my $fh, "<", $file);
    my %imap;
    while (<$fh>) {
        chomp;
        my ($chr, @etc) = split /\t/, $_;
        push @{$imap{$chr}}, \@etc;
    }
    close $fh;
    return \%imap;
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

sub locate {
    my ($pos,$aFrom,$aTo,$bSeq,$bFrom,$bTo,$ori,@etc) = @_;
    my $newpos = int(($bTo-$bFrom)*($pos-$aFrom)/($aTo-$aFrom));
    if ($ori == 1) { return [$bSeq,$bFrom + $newpos,\@etc]; }
    else { return [$bSeq, $bTo - $newpos,\@etc]; }
}

sub remap {
    my ($chrmap, $pos) = @_;
    # do a binary search to find the interval
    my @locations;
    my $i = bsearch_intervals($chrmap, $pos, 0, @$chrmap - 1);
    $i<0 and return @locations;
    push @locations, locate($pos,@{$chrmap->[$i]});
    # report overlapping intervals that start earlier
    my $j = $i-1;
    while ($j>=0 and $chrmap->[$j][1] > $pos) {
        push @locations, locate($pos,@{$chrmap->[$j]});
        $j--;
    }
    # find overlapping intervals that start later
    $j = $i+1;
    while ($j < @{$chrmap} and $chrmap->[$j][0] <= $pos) {
        push @locations, locate($pos,@{$chrmap->[$j]});
        $j++;
    }
    return @locations;
}