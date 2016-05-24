#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my ($min, $max, $stride, $file, $col) = @ARGV;

$file ||= '/dev/fd/0';
$col ||= 0;

my $n = int(($max - $min + 1)/$stride);
my @counts = (0) x $n;
open (my $fh, "<", $file);
while (<$fh>) {
  chomp;
  my @x = split /\t/, $_;
  my $bin = int(($x[$col] - $min)/$stride);
  $counts[$bin]++ if ($bin >= 0);
}
close $fh;
for(my $i=0;$i<$n;$i++) {
  my $b = $min + $i*$stride;
  print "$b\t$counts[$i]\n";
}