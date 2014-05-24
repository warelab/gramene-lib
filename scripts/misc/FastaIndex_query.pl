#!/usr/bin/perl -w
use strict;
use FastaIndex;
my $fidx = new FastaIndex;

my $dir = shift @ARGV;

$fidx->load($dir);

print STDERR "finished loading index\n";

while (<>) {
    chomp;
    my ( $seqid, $flip ) = split /\s+/, $_;
	my $seq = $fidx->fetch($seqid,$flip);
    print ">$seqid";
	$flip and print " $flip";
	print "\n$seq\n";
}

exit;
