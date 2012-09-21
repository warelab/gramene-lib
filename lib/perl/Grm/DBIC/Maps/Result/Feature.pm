package Grm::DBIC::Maps::Result::Feature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::Feature

=cut

__PACKAGE__->table("feature");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 feature_type_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 display_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 feature_acc

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "feature_type_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "species_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "display_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "feature_acc",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("feature_id");
__PACKAGE__->add_unique_constraint("feature_acc", ["feature_acc"]);

=head1 RELATIONS

=head2 display_synonym

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::FeatureSynonym>

=cut

__PACKAGE__->belongs_to(
  "display_synonym",
  "Grm::DBIC::Maps::Result::FeatureSynonym",
  { feature_synonym_id => "display_synonym_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 feature_type

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::FeatureType>

=cut

__PACKAGE__->belongs_to(
  "feature_type",
  "Grm::DBIC::Maps::Result::FeatureType",
  { feature_type_id => "feature_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Maps::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 feature_details_aflp

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsAflp>

=cut

__PACKAGE__->might_have(
  "feature_details_aflp",
  "Grm::DBIC::Maps::Result::FeatureDetailsAflp",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_centromere

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsCentromere>

=cut

__PACKAGE__->might_have(
  "feature_details_centromere",
  "Grm::DBIC::Maps::Result::FeatureDetailsCentromere",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_clone

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsClone>

=cut

__PACKAGE__->might_have(
  "feature_details_clone",
  "Grm::DBIC::Maps::Result::FeatureDetailsClone",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_est

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsEst>

=cut

__PACKAGE__->might_have(
  "feature_details_est",
  "Grm::DBIC::Maps::Result::FeatureDetailsEst",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_est_cluster

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsEstCluster>

=cut

__PACKAGE__->might_have(
  "feature_details_est_cluster",
  "Grm::DBIC::Maps::Result::FeatureDetailsEstCluster",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_gene

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsGene>

=cut

__PACKAGE__->might_have(
  "feature_details_gene",
  "Grm::DBIC::Maps::Result::FeatureDetailsGene",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_genomic_dna

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsGenomicDna>

=cut

__PACKAGE__->might_have(
  "feature_details_genomic_dna",
  "Grm::DBIC::Maps::Result::FeatureDetailsGenomicDna",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_gss

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsGss>

=cut

__PACKAGE__->might_have(
  "feature_details_gss",
  "Grm::DBIC::Maps::Result::FeatureDetailsGss",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_mrna

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsMrna>

=cut

__PACKAGE__->might_have(
  "feature_details_mrna",
  "Grm::DBIC::Maps::Result::FeatureDetailsMrna",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_primer

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsPrimer>

=cut

__PACKAGE__->might_have(
  "feature_details_primer",
  "Grm::DBIC::Maps::Result::FeatureDetailsPrimer",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_qtl

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsQtl>

=cut

__PACKAGE__->might_have(
  "feature_details_qtl",
  "Grm::DBIC::Maps::Result::FeatureDetailsQtl",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_rapd

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsRapd>

=cut

__PACKAGE__->might_have(
  "feature_details_rapd",
  "Grm::DBIC::Maps::Result::FeatureDetailsRapd",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_rflp

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsRflp>

=cut

__PACKAGE__->might_have(
  "feature_details_rflp",
  "Grm::DBIC::Maps::Result::FeatureDetailsRflp",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_snp

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsSnp>

=cut

__PACKAGE__->might_have(
  "feature_details_snp",
  "Grm::DBIC::Maps::Result::FeatureDetailsSnp",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_sscp

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsSscp>

=cut

__PACKAGE__->might_have(
  "feature_details_sscp",
  "Grm::DBIC::Maps::Result::FeatureDetailsSscp",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_ssr

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsSsr>

=cut

__PACKAGE__->might_have(
  "feature_details_ssr",
  "Grm::DBIC::Maps::Result::FeatureDetailsSsr",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_details_st

Type: might_have

Related object: L<Grm::DBIC::Maps::Result::FeatureDetailsSt>

=cut

__PACKAGE__->might_have(
  "feature_details_st",
  "Grm::DBIC::Maps::Result::FeatureDetailsSt",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_images

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::FeatureImage>

=cut

__PACKAGE__->has_many(
  "feature_images",
  "Grm::DBIC::Maps::Result::FeatureImage",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_synonyms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::FeatureSynonym>

=cut

__PACKAGE__->has_many(
  "feature_synonyms",
  "Grm::DBIC::Maps::Result::FeatureSynonym",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature_to_ontology_terms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::FeatureToOntologyTerm>

=cut

__PACKAGE__->has_many(
  "feature_to_ontology_terms",
  "Grm::DBIC::Maps::Result::FeatureToOntologyTerm",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 mappings

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Mapping>

=cut

__PACKAGE__->has_many(
  "mappings",
  "Grm::DBIC::Maps::Result::Mapping",
  { "foreign.feature_id" => "self.feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:K50gLFS3awBJPhA6WcVLYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
