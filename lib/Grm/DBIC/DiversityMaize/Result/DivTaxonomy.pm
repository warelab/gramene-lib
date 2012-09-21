package Grm::DBIC::DiversityMaize::Result::DivTaxonomy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivTaxonomy

=cut

__PACKAGE__->table("div_taxonomy");

=head1 ACCESSORS

=head2 div_taxonomy_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_taxonomy_acc

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

=head2 race

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 population

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 common_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 term_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_taxonomy_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_taxonomy_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "subspecies",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "subtaxa",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "race",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "population",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "term_accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_taxonomy_id");
__PACKAGE__->add_unique_constraint("div_taxonomy_acc", ["div_taxonomy_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7IJEmEVpU/r7nnV36e48iw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
