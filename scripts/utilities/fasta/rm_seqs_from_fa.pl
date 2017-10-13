#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $desired = shift @ARGV;
my %get_seq;
defined $desired or die "usage: $0 <desired seqs> < fasta file on STDIN or second arg";
if (-f $desired) {
  open (IN, "<", $desired);
  while (<IN>) {
    chomp;
    $get_seq{$_} = 1;
  }
  close (IN);
} else {
  print STDERR "will reinterpret $desired as a (comma separated) list of sequences\n";
  foreach my $seq (split /,/, $desired) {
    next unless ($seq =~ m/\w/);
    $get_seq{$seq} = 1;
  }
}

# read through fasta on stdin sequentially, printing desired sequences
# print a warning on STDERR if a sequence appears more than once in the fasta file
my $name;
while (<>) {
  if (/^>/) {
    if (/^>gi\|\d+\|\w+\|([^|]+\.\d+)\|/) {
      $name = $1;
    } elsif (/^>(\S+)/) {
      $name = $1;
    } else {
      $name=' ';
    }
    print $_ unless defined $get_seq{$name};
  } else {
    print $_ unless defined $get_seq{$name};
  }
}
