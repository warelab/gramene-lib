package Grm::DBIC::DiversityMaize::Result::DivAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivAllele

=cut

__PACKAGE__->table("div_allele");

=head1 ACCESSORS

=head2 div_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_obs_unit_sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 div_allele_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 referencedb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 allele_num

  data_type: 'integer'
  is_nullable: 1

=head2 quality

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'text'
  is_nullable: 1

=head2 proportion

  data_type: 'double precision'
  is_nullable: 1

=head2 total_n

  data_type: 'integer'
  is_nullable: 1

=head2 binary_value

  data_type: 'mediumblob'
  is_nullable: 1

=head2 binary_imputation

  data_type: 'mediumblob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_allele_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_obs_unit_sample_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_allele_assay_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "referencedb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "allele_num",
  { data_type => "integer", is_nullable => 1 },
  "quality",
  { data_type => "text", is_nullable => 1 },
  "value",
  { data_type => "text", is_nullable => 1 },
  "proportion",
  { data_type => "double precision", is_nullable => 1 },
  "total_n",
  { data_type => "integer", is_nullable => 1 },
  "binary_value",
  { data_type => "mediumblob", is_nullable => 1 },
  "binary_imputation",
  { data_type => "mediumblob", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_allele_id");
__PACKAGE__->add_unique_constraint("div_allele_acc", ["div_allele_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/mrHJbkgeu2viVtSTeZjig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
