#!/usr/bin/env perl
#use strict;

my $in = shift @ARGV;
my ($c1,@c2list) = @ARGV;
defined $in and defined $c1 and @c2list or die "usage $0: infile col1 col2";
open IN,$in or die "failed to open $in for reading";
my $prev_c1='FIRST_ROW';
my @y;
my $delim;
while (<IN>) {
  chomp;
  if ($_ =~ /\t/) {
    $delim = "\t";
  } elsif ($_ =~ /\s+/) {
    $delim = "\s+";
  }
  my @x = split /$delim/, $_;
  if ($x[$c1] ne $prev_c1) {
    if ($prev_c1 eq "FIRST_ROW") {
      print "$x[$c1]\t";
    } else {
      my $ystr = join ",", @y;
      print "$ystr\n";
      print "$x[$c1]\t";
      @y=();
    }
    $prev_c1 = $x[$c1];
  }
  my @cols;
  for my $c2 (@c2list) {
    push @cols, $x[$c2];
  }
  push @y, join("$delim",@cols) if (@cols);
#  push @y, $x[$c2] if defined $x[$c2];
#  print ",$x[$c2]" if defined $x[$c2];
}
my $ystr = join ',', @y;
print "$ystr\n";
#print "\n";
