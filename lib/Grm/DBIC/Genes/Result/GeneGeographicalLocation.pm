package Grm::DBIC::Genes::Result::GeneGeographicalLocation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeographicalLocation

=cut

__PACKAGE__->table("gene_geographical_location");

=head1 ACCESSORS

=head2 geographical_location_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 location_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 latitude_degree

  data_type: 'integer'
  is_nullable: 1

=head2 latitude_minute

  data_type: 'integer'
  is_nullable: 1

=head2 is_north

  data_type: 'tinyint'
  is_nullable: 1

=head2 longitude_degree

  data_type: 'integer'
  is_nullable: 1

=head2 longitude_minute

  data_type: 'integer'
  is_nullable: 1

=head2 is_west

  data_type: 'tinyint'
  is_nullable: 1

=head2 aptitude

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "geographical_location_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "location_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "latitude_degree",
  { data_type => "integer", is_nullable => 1 },
  "latitude_minute",
  { data_type => "integer", is_nullable => 1 },
  "is_north",
  { data_type => "tinyint", is_nullable => 1 },
  "longitude_degree",
  { data_type => "integer", is_nullable => 1 },
  "longitude_minute",
  { data_type => "integer", is_nullable => 1 },
  "is_west",
  { data_type => "tinyint", is_nullable => 1 },
  "aptitude",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("geographical_location_id");
__PACKAGE__->add_unique_constraint("location_name", ["location_name"]);

=head1 RELATIONS

=head2 gene_germplasms

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGermplasm>

=cut

__PACKAGE__->has_many(
  "gene_germplasms",
  "Grm::DBIC::Genes::Result::GeneGermplasm",
  {
    "foreign.geographical_location_id" => "self.geographical_location_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_studies

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneStudy>

=cut

__PACKAGE__->has_many(
  "gene_studies",
  "Grm::DBIC::Genes::Result::GeneStudy",
  {
    "foreign.geographical_location_id" => "self.geographical_location_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zwl/jHjUIjbnCf7Eun5DaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
