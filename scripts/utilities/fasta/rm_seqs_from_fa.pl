#!/usr/bin/env perl

$desired = shift @ARGV;
%get_seq;
defined $desired or die "usage: $0 <desired seqs> < fasta file on STDIN or second arg";
if (-f $desired) {
  open (IN, $desired) or die "failed to open file '$desired': $!\n";
  while (<IN>) {
    chomp;
    split;
    $get_seq{$_[0]} = 1;
  }
} else {
  print STDERR "will reinterpret $desired as a (comma separated) list of sequences\n";
  foreach $seq (split /,/, $desired) {
    next unless ($seq =~ m/\w/);
    $get_seq{$seq} = 1;
  }
}

# read through fasta on stdin sequentially, printing desired sequences
# print a warning on STDERR if a sequence appears more than once in the fasta file

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
