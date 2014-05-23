#!/usr/bin/perl -w
use strict;

use Getopt::Long;
my %args;
GetOptions( \%args, 'agp=s', 'prefix=s' );

open (my $fh, "<", $args{agp}) or die "failed to open $args{agp} for reading: $!\n";

while (<$fh>) {
	print $_;
}
close $fh;
exit;