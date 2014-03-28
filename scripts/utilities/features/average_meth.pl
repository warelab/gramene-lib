#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
my ($methFile, $genesFile, $upstream, $upbins, $downstream, $downbins) = @ARGV;
$methFile and -f $genesFile and $downstream and $upstream and $upbins and $downbins
or die "usage: $0 meth genes 1000 10 1000 10\n";
# compute average methylation levels in a variety of gene structures
# regions are divided into uniform sized bins
# regions can be simple (1kb upstream of TSS) or composite (concatenated exons)
my %regions = (
upstream => {
    length => $upstream,
    nbins  => $upbins,
    load   => \&loadUpstream,
    insert => \&insertSimple
},
downstream => {
    length => $downstream,
    nbins  => $downbins,
    load   => \&loadDownstream,
    insert => \&insertSimple
},
exonic => {
    nbins  => 10,
    load   => \&loadExonic,
    insert => \&insertComposite
}
);

my @simpleKeys = qw(id chr start end strand gLength tLength);
my @fbTypes = qw(k k i i k i i);
my @naty;
for(my $i=0;$i<@simpleKeys;$i++) {
    push @naty, "$simpleKeys[$i]:$fbTypes[$i]";
}
my @regionKeys = sort keys %regions;
for my $k (@regionKeys) {
    for (my $i=0;$i<$regions{$k}{nbins};$i++) {
        push @naty, "$k$i:f";
    }
}

print STDERR "ardea -d datadir -t file.csv -m ",join(',', @naty), "\n";

# each cluster is a hash
# with keys for chr, start, end, and a list of genes
# each gene in the list has some basic info
# chr, start, end, strand, id, tLength, gLength, and exons.
# There is also a key for each type of region
# Each region defines a set of _intervals and a set of _bins
# the bins array is 2*nbins long and alternates between sum(ratio) and count
# so that when a cluster is being output, the average ratio can be calculated
# by dividing (if count > 0)
# maybe it is better to calculate the bin methylation level by C/(C+T)
# where C and T are summed within the bin

my $clusters = loadGenes($genesFile);
my $nClusters = @$clusters;
print STDERR "finished loadGenes($genesFile) into $nClusters clusters\n";
my $clusterIdx=0;
my $clust = $clusters->[$clusterIdx];
open(my $mfh, "<", $methFile);
while (<$mfh>) { # read methpipe .meth file
    chomp;
    my ($chr, $pos, $strand, $context, $ratio, $coverage) = split /\t/, $_;

    # compare chr and pos to current cluster
    while ($chr gt $clust->{chr} or $pos >= $clust->{end}) {
        outputCluster($clust);
        $clusterIdx++;
        if ($clusterIdx == $nClusters) {
            close $mfh;
            exit;
        }
        $clust = $clusters->[$clusterIdx];
    }
    if ($chr eq $clust->{chr} and $pos >= $clust->{start}) {
        for my $gene (@{$clust->{genes}}) {
            while (my ($k,$v) = each %regions) {
                $v->{insert}($k,$gene,$pos,$ratio);
            }
        }
    }
}
close $mfh;
outputCluster($clust);
exit;

sub loadGenes {
    my $file = shift;

    open (my $fh, "<", $file);
    my @clusters;
    push @clusters, {chr => "!", start => 0, end => 0, genes => []};
    while (<$fh>) {
        chomp;
        my ($chr,$start,$end,$strand,$id,$tlen,$exonstr) = split /\t/, $_;
        my @span = ($start,$end);
        if ($strand eq '+') {
            $span[0] -= $upstream;
            $span[1] += $downstream;
        }
        else {
            $span[0] -= $downstream;
            $span[1] += $upstream;
        }
        if ($chr gt $clusters[-1]{chr} or $span[0] > $clusters[-1]{end}) {
            push @clusters, {chr => $chr, start => $span[0], end => $span[1], genes => []};
        }
        elsif ($span[1] > $clusters[-1]{end}) {
            $clusters[-1]{end} = $span[1];
        }
        
        my @exons = sort {$a <=> $b} map {split /-/} split /;/, $exonstr;
        my %gene = (chr=>$chr,start=>$start,end=>$end,strand=>$strand,id=>$id,
            tLength=>$tlen,gLength=>$end-$start,exons=>\@exons);
        while (my ($k,$v) = each %regions) {
            $v->{load}($k,\%gene);
        }
        push @{$clusters[-1]{genes}}, \%gene;
    }
    close $fh;
    shift @clusters; # remove the dummy cluster
    return \@clusters;
}

sub loadUpstream {
    my ($k,$gene) = @_;
    my ($s,$e);
    if ($gene->{strand} eq '+') {
        $s = $gene->{start} - $regions{$k}{length};
        $e = $gene->{start};
    }
    else {
        $s = $gene->{end};
        $e = $gene->{end} + $regions{$k}{length};
    }
    $gene->{$k}{interval} = [$s,$e];
    @{$gene->{$k}{bins}} = (0) x ($regions{$k}{nbins}*2);
}

sub loadDownstream {
    my ($k,$gene) = @_;
    my ($s,$e);
    if ($gene->{strand} eq '+') {
        $s = $gene->{end};
        $e = $gene->{end} + $regions{$k}{length};
    }
    else {
        $s = $gene->{start} - $regions{$k}{length};
        $e = $gene->{start};
    }
    $gene->{$k}{interval} = [$s,$e];
    @{$gene->{$k}{bins}} = (0) x ($regions{$k}{nbins}*2);
}

sub loadExonic {
    my ($k, $gene) = @_;
    $gene->{$k}{intervals} = [];
    my $offset = 0;
    for(my $i=0;$i<@{$gene->{exons}};$i+=2) {
        my $s = $gene->{exons}[$i];
        my $e = $gene->{exons}[$i+1];
        push @{$gene->{$k}{intervals}}, [$s,$e,$offset];
        $offset += $e-$s;
    }
    @{$gene->{$k}{bins}} = (0) x ($regions{$k}{nbins}*2);
}

sub insertSimple {
    my ($k,$gene,$pos,$ratio) = @_;
    my ($s,$e) = @{$gene->{$k}{interval}};
    if ($pos >= $s and $pos < $e) {
        my $bin = int(($pos - $s)*$regions{$k}{nbins}/($e-$s));
        if ($gene->{strand} eq '-') {
            $bin = $regions{$k}{nbins} - $bin - 1;
        }
        my $i = $bin * 2;
        $gene->{$k}{bins}[$i] += $ratio;
        $gene->{$k}{bins}[$i+1]++;
    }
}

sub insertComposite {
    my ($k,$gene,$pos,$ratio) = @_;
    for my $interval (@{$gene->{$k}{intervals}}) {
        my ($s,$e,$o) = @$interval;
        last if ($pos < $s);
        if ($pos < $e) {
            my $bin = int(($pos - $s + $o)*$regions{$k}{nbins}/$gene->{tLength});
            if ($gene->{strand} eq '-') {
                $bin = $regions{$k}{nbins} - $bin - 1;
            }
            my $i = $bin * 2;
            $gene->{$k}{bins}[$i] += $ratio;
            $gene->{$k}{bins}[$i+1]++;
        }
    }
}

sub outputCluster {
    my $cluster = shift;
    for my $gene (@{$cluster->{genes}}) {
        my @row = map {$gene->{$_}} @simpleKeys;
        for my $k (@regionKeys) {
            my $aRef = $gene->{$k}{bins};
            for (my $i=0;$i<@$aRef;$i+=2) {
                my ($sum,$count) = @$aRef[$i,$i+1];
                push @row, $count ? $sum/$count : '';
            }
        }
        print join (',', @row),"\n";
    }
}
