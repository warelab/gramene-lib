#!/usr/bin/env perl

$first_line = <>;
print "$first_line";
while (<>) {
  chomp;
  if (/^>/) {
    print "\n$_\n";
  } else {
    print "$_";
  }
}
print "\n";
