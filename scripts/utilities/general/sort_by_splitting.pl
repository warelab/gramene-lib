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
    my @intervals = sort {$a->[0] <=> $b->[0]} @{$fragments{$c}};
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
            if ($cluster[2] < $cluster[3]) { # need to merge these files
                my @files;
                for(my $j = $cluster[2]; $j <= $cluster[3]; $j++) {
                    push @files, "$prefix.$c.$intervals[$j][0].$intervals[$j][1]";
                }
                my $cmd = join(" ", $sort_cmd, @files) . " > $prefix.$c.$cluster[0].$cluster[1]";
                system($cmd);
                unlink @files;
            }
            push @catme, "$prefix.$c.$cluster[0].$cluster[1]";
            @cluster = ($intervals[$i][0], $intervals[$i][1], $i, $i);
        }
    }
    if ($cluster[2] < $cluster[3]) { # need to merge these files
        my @files;
        for(my $j = $cluster[2]; $j <= $cluster[3]; $j++) {
            push @files, "$prefix.$c.$intervals[$j][0].$intervals[$j][1]";
        }
        my $cmd = join(" ", $sort_cmd, @files) . " > $prefix.$c.$cluster[0].$cluster[1]";
        system($cmd);
        unlink @files;
    }
    push @catme, "$prefix.$c.$cluster[0].$cluster[1]";
}
my $cmd = "cat " . join(" ", @catme) . " > $prefix.sorted";
system($cmd);
unlink @catme;

sub flush_buffer {
    my $c = shift;
    my $b = shift;
    $fragments{$c} = [] if (not exists $fragments{$c});
    push @{$fragments{$c}}, [$$b{range}[0], $$b{range}[1]];
    open(my $fh, ">", "$prefix.$c.$$b{range}[0].$$b{range}[1]");
    for my $line (@{$b->{lines}}) {
        print $fh $line;
    }
    close $fh;
}
