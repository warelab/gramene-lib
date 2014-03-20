#!/usr/bin/env perl

# paste.pl <file 1> <column> <file 2> <column> <columns to add>
# finds lines from file 1 that match on the selected column in file 2
# and appends columsn to add onto file 1
# Note: '-' as filename takes input from STDIN

$n_args = @ARGV;
($n_args >= 5) or die "usage: paste.pl <file 1> <column> <file 2> <column> <columns to add>";

open (FILE1, $ARGV[0]) or die "failed to open '$ARGV[0]'";
open (FILE2, $ARGV[2]) or die "failed to open '$ARGV[2]'";

$add_all=0;
if ($ARGV[$n_args-1] eq '+') {
  $add_all = 1;
  pop @ARGV;
  $n_args--;
  $last_col=-1;
  $last_col = $ARGV[$n_args-1] if ($n_args>4);
}
my $delim;
while (<FILE2>) {
  chomp;
  s/^\s+//;
  if ($_ =~ /\t/) {
      $delim = "\t";
  }
  elsif ($_ =~ /\s+/) {
      $delim = "\s+";
  } else {
    $delim = "\t";
  }
#  @cols = split /\t/, $_;
  @cols = split /$delim/, $_;
  $key = $cols[$ARGV[3]];
  @values=();
  for($i=4;$i<$n_args;$i++) {
    $value='-';
    $value = $cols[$ARGV[$i]] if (defined $cols[$ARGV[$i]]);
    push @values, $value;
  }
  if ($add_all) {
    for($i=$last_col+1;$i<@cols;$i++) {
      $value='-';
      $value = $cols[$i] if (defined $cols[$i]);
      push @values, $value;
    }
  }
  $h{$key} = join "\t", @values;
}
close FILE2;

while (<FILE1>) {
  chomp;
  s/^\s+//;
  if ($_ =~ /\t/) {
      $delim = "\t";
  }
  elsif ($_ =~ /\s+/) {
      $delim = "\s+";
  } else {
    $delim = "\t";
  }
  @cols = split /$delim/, $_;
  $key = $cols[$ARGV[1]];
  if (defined $h{$key}) {
    print "$_\t$h{$key}\n";
  } else {
    print "$_\t-\n";
  }
}
close FILE1;
