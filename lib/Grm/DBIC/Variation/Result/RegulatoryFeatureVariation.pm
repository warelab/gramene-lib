use utf8;
package Grm::DBIC::Variation::Result::RegulatoryFeatureVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::RegulatoryFeatureVariation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<regulatory_feature_variation>

=cut

__PACKAGE__->table("regulatory_feature_variation");

=head1 ACCESSORS

=head2 regulatory_feature_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 variation_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 feature_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 feature_type

  data_type: 'text'
  is_nullable: 1

=head2 allele_string

  data_type: 'text'
  is_nullable: 1

=head2 somatic

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 consequence_types

  data_type: 'set'
  extra: {list => ["splice_acceptor_variant","splice_donor_variant","stop_lost","coding_sequence_variant","missense_variant","stop_gained","synonymous_variant","frameshift_variant","nc_transcript_variant","non_coding_exon_variant","mature_miRNA_variant","NMD_transcript_variant","5_prime_UTR_variant","3_prime_UTR_variant","incomplete_terminal_codon_variant","intron_variant","splice_region_variant","downstream_gene_variant","upstream_gene_variant","initiator_codon_variant","stop_retained_variant","inframe_insertion","inframe_deletion","transcript_ablation","transcript_fusion","transcript_amplification","transcript_translocation","TF_binding_site_variant","TFBS_ablation","TFBS_fusion","TFBS_amplification","TFBS_translocation","regulatory_region_variant","regulatory_region_ablation","regulatory_region_fusion","regulatory_region_amplification","regulatory_region_translocation","feature_elongation","feature_truncation"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "regulatory_feature_variation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "variation_feature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "feature_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "feature_type",
  { data_type => "text", is_nullable => 1 },
  "allele_string",
  { data_type => "text", is_nullable => 1 },
  "somatic",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "consequence_types",
  {
    data_type => "set",
    extra => {
      list => [
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
        "TF_binding_site_variant",
        "TFBS_ablation",
        "TFBS_fusion",
        "TFBS_amplification",
        "TFBS_translocation",
        "regulatory_region_variant",
        "regulatory_region_ablation",
        "regulatory_region_fusion",
        "regulatory_region_amplification",
        "regulatory_region_translocation",
        "feature_elongation",
        "feature_truncation",
      ],
    },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</regulatory_feature_variation_id>

=back

=cut

__PACKAGE__->set_primary_key("regulatory_feature_variation_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qi9eQgaO57b7s51JVjbkVA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
