#!/usr/bin/env perl

# intersect.pl <file 1> <columns> <file 2> <columns>
# finds lines from file 1 that match on selected columns in file 2
# if no columns are specified, entire lines must match
# Note: '-' as filename takes input from STDIN

my ($flag,$delim) = (0,'');
if (@ARGV >= 4 and $ARGV[0] eq "-F") {
  $flag = shift @ARGV;
  $delim = shift @ARGV;
}
$n_args = @ARGV;
(($n_args % 2 == 0) and ($n_args >= 2)) or die "usage: subtract.pl (-F <delimiter>) <file 1> <columns> <file 2> <columns>";

open (FILE1, $ARGV[0]) or die "failed to open '$ARGV[0]'";
open (FILE2, $ARGV[$n_args/2]) or die "failed to open '$ARGV[$n_args/2]'";

while (<FILE2>) {
  chomp;
  if ($n_args>2) {
    if (not $flag) {
      if ($_ =~ /\t/) {
	$delim = '\t';
      } elsif ($_ =~ /\s+/) {
	$delim = '\s+';
      } else {
	$delim = '\n';
      }
    }
    @cols = split /$delim/, $_;
    $key = '';
    for($i=$n_args/2+1;$i<$n_args;$i++) {
      $key .= $cols[$ARGV[$i]];
    }
    $h{$key} = 1;
  } else {
    $h{$_} = 1;
  }
}
close FILE2;

while (<FILE1>) {
  chomp;
  if ($n_args>2) {
    if (not $flag) {
      if ($_ =~ /\t/) {
	$delim = '\t';
      } elsif ($_ =~ /\s+/) {
	$delim = '\s+';
      } else {
	$delim = '\n';
      }
    }
    @cols = split /$delim/, $_;
    $key = '';
    for($i=1;$i<$n_args/2;$i++) {
      $key .= $cols[$ARGV[$i]];
    }
  } else {
    $key = $_;
  }
  if (!defined $h{$key}) {
    print "$_\n";
  }
}
close FILE1;
