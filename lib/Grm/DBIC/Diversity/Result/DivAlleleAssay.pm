package Grm::DBIC::Diversity::Result::DivAlleleAssay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::DivAlleleAssay

=cut

__PACKAGE__->table("div_allele_assay");

=head1 ACCESSORS

=head2 div_allele_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_assay_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_source_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_poly_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_scoring_tech_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 cdv_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 binary_position

  data_type: 'mediumblob'
  is_nullable: 1

=head2 binary_annotation

  data_type: 'mediumblob'
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 assay_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 producer

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=head2 binary_id

  data_type: 'mediumblob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_allele_assay_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_allele_assay_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_source_assay_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_poly_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_scoring_tech_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "cdv_marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "binary_position",
  { data_type => "mediumblob", is_nullable => 1 },
  "binary_annotation",
  { data_type => "mediumblob", is_nullable => 1 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "assay_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "producer",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
  "binary_id",
  { data_type => "mediumblob", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_allele_assay_id");

=head1 RELATIONS

=head2 div_aa_annotations

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::DivAaAnnotation>

=cut

__PACKAGE__->has_many(
  "div_aa_annotations",
  "Grm::DBIC::Diversity::Result::DivAaAnnotation",
  { "foreign.div_allele_assay_id" => "self.div_allele_assay_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_alleles

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::DivAllele>

=cut

__PACKAGE__->has_many(
  "div_alleles",
  "Grm::DBIC::Diversity::Result::DivAllele",
  { "foreign.div_allele_assay_id" => "self.div_allele_assay_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_scoring_tech_type

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivScoringTechType>

=cut

__PACKAGE__->belongs_to(
  "div_scoring_tech_type",
  "Grm::DBIC::Diversity::Result::DivScoringTechType",
  { div_scoring_tech_type_id => "div_scoring_tech_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_source_assay

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivAlleleAssay>

=cut

__PACKAGE__->belongs_to(
  "div_source_assay",
  "Grm::DBIC::Diversity::Result::DivAlleleAssay",
  { div_allele_assay_id => "div_source_assay_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_allele_assays

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::DivAlleleAssay>

=cut

__PACKAGE__->has_many(
  "div_allele_assays",
  "Grm::DBIC::Diversity::Result::DivAlleleAssay",
  { "foreign.div_source_assay_id" => "self.div_allele_assay_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_poly_type

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivPolyType>

=cut

__PACKAGE__->belongs_to(
  "div_poly_type",
  "Grm::DBIC::Diversity::Result::DivPolyType",
  { div_poly_type_id => "div_poly_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cdv_marker

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::CdvMarker>

=cut

__PACKAGE__->belongs_to(
  "cdv_marker",
  "Grm::DBIC::Diversity::Result::CdvMarker",
  { cdv_marker_id => "cdv_marker_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uIToMd8uYmTnhjw8zLNl0A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
