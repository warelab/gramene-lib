package Grm::DBIC::Maps::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 species_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 species

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 common_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 gramene_taxonomy_id

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 ncbi_taxonomy_id

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "species_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "species",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "gramene_taxonomy_id",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "ncbi_taxonomy_id",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);
__PACKAGE__->set_primary_key("species_id");
__PACKAGE__->add_unique_constraint("gramene_taxonomy_id", ["gramene_taxonomy_id"]);
__PACKAGE__->add_unique_constraint("species", ["species"]);
__PACKAGE__->add_unique_constraint("ncbi_taxonomy_id", ["ncbi_taxonomy_id"]);

=head1 RELATIONS

=head2 features

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->has_many(
  "features",
  "Grm::DBIC::Maps::Result::Feature",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 germplasms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Germplasm>

=cut

__PACKAGE__->has_many(
  "germplasms",
  "Grm::DBIC::Maps::Result::Germplasm",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 map_sets

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::MapSet>

=cut

__PACKAGE__->has_many(
  "map_sets",
  "Grm::DBIC::Maps::Result::MapSet",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-11-14 13:42:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VhRQ+GBkIOQAzTSsTknchw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
