#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
my $chr = shift @ARGV;
my $pos = shift @ARGV;
my $prefix = shift @ARGV;
my $bufSize = shift @ARGV;
$prefix or die "usage: $0 <chr column offset> <position column offset> <outprefix> <buffer size default 1000000>\n";

$bufSize |= 1000000;

my $kchr = $chr+1;
my $kpos = $pos+1;
my $sort_cmd = "sort -m -k$kchr,$kchr -k$kpos,${kpos}n";

my %buffers;
my %fragments;
while (<>) {
    my @x = split /\t/, $_;
    if (not exists $buffers{$x[$chr]}) {
        $buffers{$x[$chr]}{range} = [$x[$pos],$x[$pos]];
        $buffers{$x[$chr]}{lines} = [$_];
        $buffers{$x[$chr]}{sorted} = 0;
    }
    else {
        my $b = $buffers{$x[$chr]};
        if ($b->{sorted} == 0) { # don't know the direction yet
            if ($x[$pos] > $b->{range}[1]) {
                $b->{sorted} = 1;
            }
            elsif ($x[$pos] < $b->{range}[0]) {
                $b->{sorted} = -1;
            }
            else { # same chr/pos
                push @{$b->{lines}}, $_;
            }
        }
        if ($b->{sorted} == 1) { # ascending
            if ($x[$pos] >= $b->{range}[1]) {
                push @{$b->{lines}}, $_;
                $b->{range}[1] = $x[$pos];
            }
            else {
                flush_buffer($x[$chr],$b);
                $b->{range} = [$x[$pos],$x[$pos]];
                $b->{lines} = [$_];
                $b->{sorted} = 0;
            }
        }
        elsif ($b->{sorted} == -1) { # desc
            if ($x[$pos] <= $b->{range}[0]) {
                unshift @{$b->{lines}}, $_;
                $b->{range}[0] = $x[$pos];
            }
            else {
            flush_buffer($x[$chr],$b);
            $b->{range} = [$x[$pos],$x[$pos]];
            $b->{lines} = [$_];
            $b->{sorted} = 0;
            }
        }
        if (@{$b->{lines}} == $bufSize) {
            flush_buffer($x[$chr], $b);
            delete $buffers{$x[$chr]};
        }
    }
}

for my $k (keys %buffers) {
    flush_buffer($k,$buffers{$k});
    delete $buffers{$k};
}

my @catme;
for my $c (sort keys %fragments) {
    my @intervals;
    for my $s (sort {$a <=> $b} keys %{$fragments{$c}}) {
        for (my $i=0; $i<@{$fragments{$c}{$s}}; $i++) {
            my $e = $fragments{$c}{$s}[$i];
            push @intervals, [$s,$e,$i+1];
        }
    }
    # find overlapping intervals
    # cluster is 4-tuple (start pos, end pos, start interval, end interval)
    my @cluster = ($intervals[0][0], $intervals[0][1], 0, 0);
    for (my $i=1;$i<@intervals;$i++) {
        if ($intervals[$i][0] <= $cluster[1]) {
            $cluster[3] = $i;
            if ($intervals[$i][1] > $cluster[1]) {
                $cluster[1] = $intervals[$i][1];
            }
        }
        else { # no overlap, process previous cluster
            my $fname = "$prefix.$c.$cluster[0].$cluster[1]";
            if ($cluster[2] < $cluster[3]) { # need to merge these files
                my @files;
                for(my $j = $cluster[2]; $j <= $cluster[3]; $j++) {
                    push @files, join('.', $prefix, $c, @{$intervals[$j]});
                }
                my $cmd = join(" ", $sort_cmd, @files) . " > $fname";
                system($cmd);
                unlink @files;
            }
            else {
                $fname .= ".1";
            }
            push @catme, $fname;
            @cluster = ($intervals[$i][0], $intervals[$i][1], $i, $i);
        }
    }
    my $fname = "$prefix.$c.$cluster[0].$cluster[1]";
    if ($cluster[2] < $cluster[3]) { # need to merge these files
        my @files;
        for(my $j = $cluster[2]; $j <= $cluster[3]; $j++) {
            push @files, join('.', $prefix, $c, @{$intervals[$j]});
        }
        my $cmd = join(" ", $sort_cmd, @files) . " > $fname";
        system($cmd);
        unlink @files;
    }
    else {
        $fname .= ".1";
    }
    push @catme, $fname;
}
my $cmd = "cat " . join(" ", @catme) . " > $prefix.sorted";
system($cmd);
unlink @catme;

sub flush_buffer {
    my $c = shift;
    my $b = shift;
    $fragments{$c} = {} if (not exists $fragments{$c});
    my ($s,$e) = @{$$b{range}};
    push @{$fragments{$c}{$s}}, $e;
    my $fname = join('.',$prefix,$c,$s,$e,scalar @{$fragments{$c}{$s}});
    open(my $fh, ">", $fname);
    for my $line (@{$b->{lines}}) {
        print $fh $line;
    }
    close $fh;
}
