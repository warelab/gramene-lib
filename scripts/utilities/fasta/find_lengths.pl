#!/usr/bin/env perl
$length=-1;
while (<>) {
  if (/^>(\S+)/) {
    print "$name $length\n" if ($length != -1);
    $length=0;
    $name=$1;
    next;
  }
  chomp;
  $length += length $_;
}
print "$name $length\n" if ($length != -1);
