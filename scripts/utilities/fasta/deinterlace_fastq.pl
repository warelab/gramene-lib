#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $fastq = shift @ARGV;
my $outprefix = shift @ARGV;
my $split = shift @ARGV;
my $a = shift @ARGV;
$a ||= 4;
$outprefix or die "usage: $0 fastq outprefix [split size [suffix length]]\n";

my @fha;
$fha[0] = 'error';
if ($split) {
    my $l = $split*4;
    open ($fha[1], "| split -a $a -l $l -d /dev/fd/0 ${outprefix}1.");
    open ($fha[2], "| split -a $a -l $l -d /dev/fd/0 ${outprefix}2.");
}
else {
    open ($fha[1],">",$outprefix.1);
    open ($fha[2],">",$outprefix.2);
}
my $fh;
my $nr=0;
my $i=-1;
open (my $fq, "<", $fastq);
while (<$fq>) {
    $nr++;
    if (($nr % 4) == 1) {
        $i *= -1;
        $fh = $fha[$i];
    }
    print $fh $_;
}
close $fq;
close $fha[2];
close $fha[1];

