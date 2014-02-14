#!/usr/bin/env perl

$desired = shift @ARGV;
%get_seq;
defined $desired or die "usage: $0 <desired seqs> < fasta file on STDIN or second arg";
my $usegi=1;
if (-f $desired) {
  open (IN, $desired) or die "failed to open file '$desired': $!\n";
  while (<IN>) {
    chomp;
    split;
    $_[0] =~ s/^>//;
    $usegi=0 if ($usegi and $_[0] !~ /^\d+$/);
    $get_seq{$_[0]} = $_[1] ? $_[1] : 1;
  }
} else {
  print STDERR "will reinterpret $desired as a (comma separated) list of sequences\n";
  foreach $seq (split /,/, $desired) {
    next unless ($seq =~ m/\w/);
    $usegi=0 if ($usegi and $seq !~ /^\d+$/);
    $get_seq{$seq} = 1;
  }
}

print STDERR "finished reading desired list gilist=$usegi\n";
# read through fasta on stdin sequentially, printing desired sequences
# print a warning on STDERR if a sequence appears more than once in the fasta file
my %seen;
while (<>) {
    if (/^>/) {
        if ($usegi) {
            if (/^>gi\|(\d+)/) {
                $name = $1;
            }
            elsif(/^>(\d+)/) {
                $name=$1;
            }
        }
        else {
            if (/^>gi\|(\d+)\|\w+\|([^|]+\.\d+)\|?/) {
                if ($usegi) {
                    $name = $1;
                }
                else {
                    $name = $2;
                }
            }
            elsif (/^>(\S+)/) {
                $name = $1;
            }
            else {
                $name=' ';
            }
        }
        if ($get_seq{$name}) {
            $seen{$name}++;
            if ($seen{$name}>1) {
                print STDERR "$name appears multiple times in the input\n";
                next;
            }
            if ($get_seq{$name} != 1) {
                if (!$usegi) {
                    $_ =~ s/$name/$get_seq{$name}/;
                }
            }
            print $_;
        }
    }
    else {
        print $_ if ($seen{$name}==1);
    }
}
