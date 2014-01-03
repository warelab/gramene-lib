use utf8;
package Grm::DBIC::Variation::Result::VariationFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::VariationFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<variation_feature>

=cut

__PACKAGE__->table("variation_feature");

=head1 ACCESSORS

=head2 variation_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 allele_string

  data_type: 'varchar'
  is_nullable: 1
  size: 50000

=head2 variation_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 map_weight

  data_type: 'integer'
  is_nullable: 0

=head2 flags

  data_type: 'set'
  extra: {list => ["genotyped"]}
  is_nullable: 1

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 validation_status

  data_type: 'set'
  extra: {list => ["cluster","freq","submitter","doublehit","hapmap","1000Genome","precious"]}
  is_nullable: 1

=head2 consequence_types

  data_type: 'set'
  default_value: 'intergenic_variant'
  extra: {list => ["intergenic_variant","splice_acceptor_variant","splice_donor_variant","stop_lost","coding_sequence_variant","missense_variant","stop_gained","synonymous_variant","frameshift_variant","nc_transcript_variant","non_coding_exon_variant","mature_miRNA_variant","NMD_transcript_variant","5_prime_UTR_variant","3_prime_UTR_variant","incomplete_terminal_codon_variant","intron_variant","splice_region_variant","downstream_gene_variant","upstream_gene_variant","initiator_codon_variant","stop_retained_variant","inframe_insertion","inframe_deletion","transcript_ablation","transcript_fusion","transcript_amplification","transcript_translocation","TFBS_ablation","TFBS_fusion","TFBS_amplification","TFBS_translocation","regulatory_region_ablation","regulatory_region_fusion","regulatory_region_amplification","regulatory_region_translocation","feature_elongation","feature_truncation","regulatory_region_variant","TF_binding_site_variant"]}
  is_nullable: 0

=head2 variation_set_id

  data_type: 'set'
  default_value: (empty string)
  extra: {list => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64]}
  is_nullable: 0

=head2 class_attrib_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 somatic

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 minor_allele

  data_type: 'char'
  is_nullable: 1
  size: 50

=head2 minor_allele_freq

  data_type: 'float'
  is_nullable: 1

=head2 minor_allele_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 alignment_quality

  data_type: 'double precision'
  is_nullable: 1

=head2 evidence

  data_type: 'set'
  extra: {list => ["Multiple_observations","Frequency","HapMap","1000Genomes","Cited"]}
  is_nullable: 1

=head2 clinical_significance

  data_type: 'set'
  extra: {list => ["drug-response","histocompatibility","non-pathogenic","other","pathogenic","probable-non-pathogenic","probable-pathogenic'unknown","untested"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "variation_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_start",
  { data_type => "integer", is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "allele_string",
  { data_type => "varchar", is_nullable => 1, size => 50000 },
  "variation_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "map_weight",
  { data_type => "integer", is_nullable => 0 },
  "flags",
  {
    data_type => "set",
    extra => { list => ["genotyped"] },
    is_nullable => 1,
  },
  "source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "validation_status",
  {
    data_type => "set",
    extra => {
      list => [
        "cluster",
        "freq",
        "submitter",
        "doublehit",
        "hapmap",
        "1000Genome",
        "precious",
      ],
    },
    is_nullable => 1,
  },
  "consequence_types",
  {
    data_type => "set",
    default_value => "intergenic_variant",
    extra => {
      list => [
        "intergenic_variant",
        "splice_acceptor_variant",
        "splice_donor_variant",
        "stop_lost",
        "coding_sequence_variant",
        "missense_variant",
        "stop_gained",
        "synonymous_variant",
        "frameshift_variant",
        "nc_transcript_variant",
        "non_coding_exon_variant",
        "mature_miRNA_variant",
        "NMD_transcript_variant",
        "5_prime_UTR_variant",
        "3_prime_UTR_variant",
        "incomplete_terminal_codon_variant",
        "intron_variant",
        "splice_region_variant",
        "downstream_gene_variant",
        "upstream_gene_variant",
        "initiator_codon_variant",
        "stop_retained_variant",
        "inframe_insertion",
        "inframe_deletion",
        "transcript_ablation",
        "transcript_fusion",
        "transcript_amplification",
        "transcript_translocation",
        "TFBS_ablation",
        "TFBS_fusion",
        "TFBS_amplification",
        "TFBS_translocation",
        "regulatory_region_ablation",
        "regulatory_region_fusion",
        "regulatory_region_amplification",
        "regulatory_region_translocation",
        "feature_elongation",
        "feature_truncation",
        "regulatory_region_variant",
        "TF_binding_site_variant",
      ],
    },
    is_nullable => 0,
  },
  "variation_set_id",
  {
    data_type => "set",
    default_value => "",
    extra => { list => [1 .. 64] },
    is_nullable => 0,
  },
  "class_attrib_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "somatic",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "minor_allele",
  { data_type => "char", is_nullable => 1, size => 50 },
  "minor_allele_freq",
  { data_type => "float", is_nullable => 1 },
  "minor_allele_count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "alignment_quality",
  { data_type => "double precision", is_nullable => 1 },
  "evidence",
  {
    data_type => "set",
    extra => {
      list => [
        "Multiple_observations",
        "Frequency",
        "HapMap",
        "1000Genomes",
        "Cited",
      ],
    },
    is_nullable => 1,
  },
  "clinical_significance",
  {
    data_type => "set",
    extra => {
      list => [
        "drug-response",
        "histocompatibility",
        "non-pathogenic",
        "other",
        "pathogenic",
        "probable-non-pathogenic",
        "probable-pathogenic'unknown",
        "untested",
      ],
    },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</variation_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("variation_feature_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VFNvlr7lCYnRZpbnOeCIow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
