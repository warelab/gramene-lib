#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $gff_file = shift @ARGV;
my $up = shift @ARGV; # upstream of gene start
my $down = shift @ARGV; # downstream of gene end
my $body = shift @ARGV; # normalized length of gene body
my $label = shift @ARGV;
$label or $label = "genebody";

my $gff = parseGFF($gff_file);

for my $gene (@{$gff->{gene}}) {
    my $strand = ($gff->{$gene}{strand} eq '+') ? 1 : -1;
    my $chr = $gff->{$gene}{chr};
    if ($strand == 1) {
        print join ("\t",
            $chr,
            $gff->{$gene}{start} - $up,
            $gff->{$gene}{start},
            $label,
            0-$up,
            0,
            $strand,$gene
        ),"\n";
    }
    else {
        print join ("\t",
            $chr,
            $gff->{$gene}{start} - $up,
            $gff->{$gene}{start},
            $label,
            $body,
            $body + $down,
            $strand,$gene
        ),"\n";
    }
    for my $mRNA (@{$gff->{children}{$gene}}) {
        next if ($gff->{$mRNA}{type} ne "mRNA");
        next if ($gff->{$mRNA}{longest} == 0); # only consider the longest mRNA
        my @intervals;
        my $length=0;
        for my $child (@{$gff->{children}{$mRNA}}) {
            next if ($gff->{$child}{type} ne "exon");
            push @intervals, [$gff->{$child}{start}, $gff->{$child}{end}];
            $length += $gff->{$child}{end} - $gff->{$child}{start};
        }
        my $ratio = $body/$length;
        my $length2=0;
        for my $interval (sort {$a->[0] <=> $b->[0]} @intervals) {
            my ($from, $to) = @$interval;
            my $ilength = $to - $from;
            $from = int($ratio * $length2);
            $length2 += $ilength;
            $to = int($ratio * $length2 + 0.5);
            if ($strand == 1) {
                print join ("\t",
                    $chr,
                    @$interval,
                    $label,
                    $from,
                    $to,
                    $strand,$gene
                ),"\n";
            }
            else {
                print join ("\t",
                    $chr,
                    @$interval,
                    $label,
                    $body - $to,
                    $body - $from,
                    $strand,$gene
                ), "\n";
            }
        }
    }
    if ($strand == -1) {
        print join ("\t",
            $chr,
            $gff->{$gene}{end},
            $gff->{$gene}{end} + $down,
            $label,
            0-$up,
            0,
            $strand,$gene
        ),"\n";
    }
    else {
        print join ("\t",
            $chr,
            $gff->{$gene}{end},
            $gff->{$gene}{end} + $down,
            $label,
            $body,
            $body + $down,
            $strand,$gene
        ),"\n";
    }
}

exit;


sub parseGFF {
    my $file = shift;
    my $fh;
    if ($file =~ m/\.gz$/) {
        open ($fh, "gzip -cd $file |");
    }
    else {
        open ($fh, "<", $file);
    }
    my %gff;
    while (<$fh>) {
        next if (/^\#/);
        chomp;
        my ($chr,$method,$type,$start,$end,$score,$strand,$phase,$col9) = split /\t/, $_;
        $start--;
        my %attr;
        for my $kv (split /;/, $col9) {
            if (my ($k,$v) = $kv =~ m/(.+)=(.+)/) { # ignore complexities
                $attr{$k} = $v;
            }
        }
        push @{$gff{$type}}, $attr{ID};
        $gff{$attr{ID}} = {type => $type, chr => $chr, start => $start, end => $end, strand => $strand};
        for my $k (keys %attr) {
            if ($k eq 'Parent') {
                push @{$gff{children}{$attr{Parent}}}, $attr{ID};
            }
            elsif ($k ne 'ID') {
                $gff{$attr{ID}}{$k} = $attr{$k};
            }
        }
    }
    
    close $fh;
    return \%gff;
}