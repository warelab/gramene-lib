#!/usr/bin/env perl
use strict;
use warnings;

my $outprefix = shift @ARGV;
my @fha;
$fha[0] = 'error';
open ($fha[2],">",$outprefix.2);
open ($fha[1],">",$outprefix.1);
my $fh;
my $nr=0;
my $i=-1;
while (<>) {
    $nr++;
    if (($nr % 4) == 1) {
        $i *= -1;
        $fh = $fha[$i];
    }
    print $fh $_;
}
close $fha[2];
close $fha[1];

