#!/usr/bin/env perl
use strict;

my $col = shift @ARGV;
my $sum=0;
while (<>) {
  my @x = split;
  $sum += $x[$col];
}
print "$sum\n";
