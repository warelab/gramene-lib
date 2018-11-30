#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my $orthologs_file = shift @ARGV;
my $source_gtf     = shift @ARGV;

$orthologs_file and $source_gtf
  or die "usage: $0 one2one_orthologs_wga.txt source.gtf\n";

# read orthlog pairs whole genome alignments into memory

open( my $fh, "<", $orthologs_file );
my %genomic_alignments;
while ( my $line = <$fh> ) {
    chomp $line;
    my ( $source_gene, $target_gene, @alignments ) = split /\t/, $line;
    $genomic_alignments{$source_gene} = [] unless exists $genomic_alignments{$source_gene};
    push @{ $genomic_alignments{$source_gene} }, \@alignments;
}
close $fh;

# read through the gtf file and convert coordinates from source to target if we have the gene_id in %genomic_alignments
open( $fh, "<", $source_gtf );
my %failed;
my @mapped;
while ( my $line = <$fh> ) {
    chomp $line;
    next if ( $line =~ m/^#/ );
    my (
        $chr,    $method, $feature,
        $start,  $end,    $score,
        $strand, $phase,  $attributeString
    ) = split /\t/, $line;
    my ($gene_id) = $attributeString =~ m/gene_id\s\"(\w+)"/;
    next unless exists $genomic_alignments{$gene_id};
    next if ( $failed{$gene_id} );

    # do the conversion for the start and end coordinates
    my ( $newChr, $newStart, $newEnd, $newStrand ) =
      convert( $chr, $start, $end, $strand, $genomic_alignments{$gene_id} );
    if ( not $newChr ) {
        $failed{$gene_id} = 1;
    }
    else {
        push @mapped,
          [
            $gene_id,  $newChr, $method, $feature,
            $newStart, $newEnd, $score,  $newStrand,
            $phase,    $attributeString
          ];
    }
}
close $fh;

for my $interval (
    sort { $a->[1] cmp $b->[1] or $a->[4] <=> $b->[4] or $b->[5] <=> $a->[5] }
    @mapped )
{
    my $gene_id = shift @$interval;
    next if $failed{$gene_id};
    print join( "\t", @$interval ), "\n";
}

sub convert {
    my ( $chr, $start, $end, $strand, $alignments ) = @_;
    my ( $newStart, $newEnd, $newChr, $newStrand ) = ( -1, -1, -1, -1 );
    my %regions;
    for my $alignment (@$alignments) {
        my (
            $source_region, $source_start,  $source_end,   $source_strand,
            $source_cigar,  $target_region, $target_start, $target_end,
            $target_strand, $target_cigar
        ) = @$alignment;
        if ( $start <= $source_end and $start >= $source_start ) { # found interval covering $start
            my $align_pos = map_seq_pos_to_alignment_pos( $start - $source_start, $source_cigar );
            $newStart = map_alignment_pos_to_seq_pos(
                $align_pos,  $target_cigar,
                $target_start, $target_end, $target_strand
            );
            if ( $newStart >= 0 ) {
                $regions{$target_region} = 1;
                $newChr                  = $target_region;
                $newStrand               = $strand;
                if ( $target_strand == -1 ) {
                    $newStrand = $strand eq '+' ? '-' : '+';
                }
            }
        }
        if ( $end <= $source_end and $end >= $source_start ) { # found interval covering $end
            my $align_pos = map_seq_pos_to_alignment_pos( $end - $source_start, $source_cigar );
            $newEnd = map_alignment_pos_to_seq_pos(
                $align_pos,  $target_cigar,
                $target_start, $target_end, $target_strand
            );
            $regions{$target_region} = 1 if ( $newEnd >= 0 );
        }
    }
    my @newRegions = keys %regions;
    return () if ( $newStart == -1 or $newEnd == -1 or @newRegions > 1 ); # failed to map both ends uniquely
    return ( $newChr, $newStart, $newEnd, $newStrand ) if ( $newStart < $newEnd );
    return ( $newChr, $newEnd, $newStart, $newStrand );
}

sub map_seq_pos_to_alignment_pos {
    my ( $spos, $cigar ) = @_;
    return -1 if ( $spos < 0 );
    my @MD           = split /[MD]/, $cigar;
    my $apos         = 0;
    my $current_spos = 0;
    for ( my $i = 0 ; $i < @MD ; $i++ ) {
        my $span = $MD[$i] || 1;
        $apos += $span;
        if ( $i % 2 == 0 ) {    # M
            $current_spos += $span;
            if ( $current_spos >= $spos ) {
                $current_spos -= $span;
                $apos         -= $span;
                $apos += $spos - $current_spos;
                return $apos;
            }
        }
    }
    return -1;
}

sub map_alignment_pos_to_seq_pos {
    my ( $apos, $cigar, $target_start, $target_end, $target_strand ) = @_;
    return -1 if ( $apos < 0 );
    my @MD           = split /[MD]/, $cigar;
    my $spos         = 0;
    my $current_apos = 0;
    for ( my $i = 0 ; $i < @MD ; $i++ ) {
        my $span = $MD[$i] || 1;
        $current_apos += $span;
        if ( $i % 2 == 0 ) {    # M
            $spos += $span;
            if ( $current_apos >= $apos ) {
                $current_apos -= $span;
                $spos         -= $span;
                $spos += $apos - $current_apos;
                return ( $target_strand == 1 )
                  ? $spos + $target_start
                  : $target_end - $spos;
            }
        }
    }
    return -1;
}
