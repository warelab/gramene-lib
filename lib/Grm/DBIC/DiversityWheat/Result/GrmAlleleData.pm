package Grm::DBIC::DiversityWheat::Result::GrmAlleleData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::GrmAlleleData

=cut

__PACKAGE__->table("grm_allele_data");

=head1 ACCESSORS

=head2 grm_allele_data_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_experiment_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cdv_marker_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 marker_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_passport_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 passport_accename

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 passport_accenumb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 subspecies

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 subtaxa

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 seed_lot

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_obs_unit_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 allele_num

  data_type: 'integer'
  is_nullable: 1

=head2 allele_value

  data_type: 'text'
  is_nullable: 1

=head2 div_allele_assay_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 genotype

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "grm_allele_data_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_experiment_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cdv_marker_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "marker_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_passport_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "passport_accename",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "passport_accenumb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "subspecies",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "subtaxa",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "seed_lot",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_obs_unit_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "allele_num",
  { data_type => "integer", is_nullable => 1 },
  "allele_value",
  { data_type => "text", is_nullable => 1 },
  "div_allele_assay_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "genotype",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("grm_allele_data_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kdCLgPM9QJbs3wCOxDgrsA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
