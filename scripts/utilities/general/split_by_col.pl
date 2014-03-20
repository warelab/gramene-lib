#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $col = shift @ARGV;
my $prefix = shift @ARGV;

my $fh;
my %fhsh;
while (<>) {
    my @x = split /\t/, $_;
    if (not exists $fhsh{$x[$col]}) {
	open ($fhsh{$x[$col]},">",$prefix.".$x[$col]");
    }
    $fh = $fhsh{$x[$col]};
    print $fh $_;
}
for my $k (keys %fhsh) {
    close $fhsh{$k};
}
