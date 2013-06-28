package Grm::DBIC::Genes::Result::GeneStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneStudy

=cut

__PACKAGE__->table("gene_study");

=head1 ACCESSORS

=head2 study_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 year

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 season

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 geographical_location_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 study_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 environmental_factors

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "study_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "year",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "season",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "geographical_location_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "study_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "environmental_factors",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("study_id");

=head1 RELATIONS

=head2 gene_objects_to_study

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneObjectToStudy>

=cut

__PACKAGE__->has_many(
  "gene_objects_to_study",
  "Grm::DBIC::Genes::Result::GeneObjectToStudy",
  { "foreign.study_id" => "self.study_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 geographical_location

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGeographicalLocation>

=cut

__PACKAGE__->belongs_to(
  "geographical_location",
  "Grm::DBIC::Genes::Result::GeneGeographicalLocation",
  { geographical_location_id => "geographical_location_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 study_type

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneStudyType>

=cut

__PACKAGE__->belongs_to(
  "study_type",
  "Grm::DBIC::Genes::Result::GeneStudyType",
  { study_type_id => "study_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PSP1JYF0mOpitXBBBkr4mw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
