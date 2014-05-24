#!/usr/bin/perl -w
use strict;

use FastaIndex;

my $fidx = new FastaIndex;

my $dir = shift @ARGV;

$fidx->index($dir);
exit;
