package Grm::DBIC::DiversityMaize::Result::DivAlleleAssay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivAlleleAssay

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
  is_nullable: 1

=head2 div_poly_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 div_scoring_tech_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cdv_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
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

=head2 binary_position

  data_type: 'mediumblob'
  is_nullable: 1

=head2 binary_annotation

  data_type: 'mediumblob'
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
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_poly_type_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_scoring_tech_type_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cdv_marker_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
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
  "binary_position",
  { data_type => "mediumblob", is_nullable => 1 },
  "binary_annotation",
  { data_type => "mediumblob", is_nullable => 1 },
  "binary_id",
  { data_type => "mediumblob", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_allele_assay_id");
__PACKAGE__->add_unique_constraint("div_allele_assay_acc", ["div_allele_assay_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VuiAqjYm2NIrM35JvmprXA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
