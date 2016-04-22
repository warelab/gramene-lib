#!/usr/bin/env perl
use strict;
use warnings;

# paste.pl <file 1> <columns> <file 2> <columns> <columns to add>
# finds lines from file 1 that match on the selected columns in file 2
# and appends columns to add onto file 1
# if no matching row in file2, appends '-'
# Note: '-' as filename takes input from STDIN
my $usage = "usage: paste.pl <file 1> <columns> <file 2> <matching columns> <columns to add>\n";
my $n_args = @ARGV;
($n_args >= 5) or die $usage;

my ($fh1,$fh2,@cols1,@cols2,@colsToAdd);

open ($fh1, $ARGV[0]) or die "failed to open '$ARGV[0]'";

push @cols1, $ARGV[1];
for(my $i=2;$i<@ARGV-1;$i++) {
  if ($fh2) {
    if (@cols2 < @cols1) {
      $ARGV[$i] =~ m/^\d+$/ or die "invalid column index 1 '$ARGV[$i]'\n";
      push @cols2, $ARGV[$i];
    }
    else {
      $ARGV[$i] =~ m/^\d+$/ or die "invalid column index 2 '$ARGV[$i]'\n";
      push @colsToAdd, $ARGV[$i];
    }
  }
  elsif (not open($fh2, $ARGV[$i])) {
    $fh2 =undef;
    $ARGV[$i] =~ m/^\d+$/ or die "invalid column index 3 '$ARGV[$i]'\n";
    push @cols1, $ARGV[$i];
  }
  else {
    # we have $fh2 and are done with @cols1
  }
}
if ($ARGV[-1] eq '+' or $ARGV[-1] =~ m/^\d+$/) {
  push @colsToAdd, $ARGV[-1];
}
else {
  die "invalid column index '$ARGV[-1]'\n";
}

$fh2 and @cols1 and @cols2 and @colsToAdd or die $usage;

my $alsoAdd = 0;
my $alsoAddFrom = 0;
if ($colsToAdd[-1] eq '+') {
  $alsoAdd = 1;
  pop @colsToAdd;
  if (@colsToAdd) {
    $alsoAddFrom = $colsToAdd[-1] + 1;
  }
}

my %h;
my $delim = "\t";
my $maxColsToAdd = 1;
while (<$fh2>) {
  chomp;
  my @cols = split /$delim/, $_;
  my $key = construct_key(\@cols,\@cols2);
  my @values;
  for my $i (@colsToAdd) {
    if ($i < @cols) {
      push @values, $cols[$i];
    }
    else {
      push @values, '-';
    }
  }
  if ($alsoAdd) {
    for (my $i=$alsoAddFrom;$i<@cols;$i++) {
      push @values, $cols[$i];
    }
  }
  if (@values > $maxColsToAdd) {
    $maxColsToAdd = @values;
  }
  $h{$key} = join $delim, @values;
}
close $fh2;

while (<$fh1>) {
  chomp;
  my @cols = split /$delim/, $_;
  my $key = construct_key(\@cols,\@cols1);
  if (defined $h{$key}) {
    print "$_\t$h{$key}\n";
  } else {
    print join("\t", $_, ('-') x $maxColsToAdd),"\n";
  }
}
close $fh1;

sub construct_key {
  my ($aref,$qcols) = @_;
  my @q;
  for my $i (@$qcols) {
    if ($i < @$aref) {
      push @q, $$aref[$i];
    }
    else {
      push @q, '-';
    }
  }
  return join $delim, @q;
}
