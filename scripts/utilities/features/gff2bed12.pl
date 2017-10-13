#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

my @GFF_columns = qw(chr method type start end score strand phase);
my %ptype = (
  mRNA => 'gene',
  exon => 'mRNA',
  CDS  => 'mRNA',
  five_prime_UTR => 'mRNA',
  three_prime_UTR => 'mRNA'
);

my %features;
my %tally;
while (<>) {
  chomp;
  my @x = split /\t/;
  my $attributes = pop @x;
  exists $ptype{$x[2]} or $x[2] eq 'gene' or next;
  # print STDERR "@x\n";
  my %feature;
  for (my $i=0; $i<@x; $i++) {
    $feature{$GFF_columns[$i]} = $x[$i];
  }
  for my $fld ( split /;/, $attributes ) {
    my ( $key, $val ) = split /=/, $fld;
    $feature{ lc $key } = $val;
  }
  my $uid = $feature{id};
  if (exists $ptype{$feature{type}} and $ptype{$feature{type}} eq 'mRNA') {
    $tally{$uid}++;
    $uid .= $tally{$uid};
  }
  $features{$feature{type}}{$uid} = \%feature;
}
# link features to parent features
for my $type (qw(mRNA CDS five_prime_UTR three_prime_UTR)) {
  for my $id (keys %{$features{$type}}) {
    my $feature = $features{$type}{$id};
    my $p_id = $feature->{parent};
    push @{$features{$ptype{$type}}{$p_id}{$type}}, $feature;
  }
}

for my $gene (values %{$features{gene}}) {
  my $chrom = $gene->{chr};
  my $strand = $gene->{strand};
  my @types = $strand eq '+' ?
    qw(five_prime_UTR CDS three_prime_UTR) :
    qw(three_prime_UTR CDS five_prime_UTR);
  
  for my $tr (@{$gene->{mRNA}}) {
    my $chromStart = $tr->{start}-1;
    my $chromEnd   = $tr->{end};
    my $thickStart = $chromStart;
    my $thickEnd   = $chromEnd;
    my @blockSizes;
    my @blockStarts;
    for my $type (@types) {
      if (exists $tr->{$type}) {
        my @blocks = sort {$a->{start} <=> $b->{start}} @{$tr->{$type}};
        for my $block (@blocks) {
          push @blockStarts, $block->{start} - $chromStart - 1;
          push @blockSizes, $block->{end} - $block->{start} + 1;
        }
        if ($type eq 'CDS') {
          $thickStart = $blocks[0]->{start} - 1;
          $thickEnd   = $blocks[-1]->{end};
        }
      }
    }
    print join("\t",
      $chrom,
      $chromStart,
      $chromEnd,
      $tr->{name},
      0,              # score
      $strand,
      $thickStart,
      $thickEnd,
      0,              # itemRgb
      scalar @blockSizes,
      join(',',@blockSizes),
      join(',',@blockStarts),
    ),"\n";
  }
}
