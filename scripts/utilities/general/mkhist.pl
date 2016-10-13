#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my ($min, $max, $stride, $file, $col) = @ARGV;

$stride or die "usage: $0 <min> <max> <stride> [input file] [column number]\n";

$file ||= '/dev/fd/0';
$col ||= 0;

my $n = int(($max - $min)/$stride);
my @counts = (0) x $n;
open (my $fh, "<", $file);
while (<$fh>) {
  chomp;
  my @x = split /\t/, $_;
  next if ($x[$col] < $min or $x[$col] > $max);
  $counts[int(($x[$col] - $min)/$stride)]++;
}
close $fh;
for(my $i=0;$i<$n;$i++) {
  my $b = $min + $i*$stride;
  print "$b\t$counts[$i]\n";
}