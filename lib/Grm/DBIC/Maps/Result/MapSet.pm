package Grm::DBIC::Maps::Result::MapSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::MapSet

=cut

__PACKAGE__->table("map_set");

=head1 ACCESSORS

=head2 map_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 map_type_id

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

=head2 map_set_acc

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 30

=head2 map_set_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 total_length

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 distance_unit

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 published_on

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "map_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "map_type_id",
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
  "map_set_acc",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 30 },
  "map_set_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "total_length",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "distance_unit",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "published_on",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("map_set_id");
__PACKAGE__->add_unique_constraint("map_set_acc", ["map_set_acc"]);

=head1 RELATIONS

=head2 germplasms_to_map_set

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::GermplasmToMapSet>

=cut

__PACKAGE__->has_many(
  "germplasms_to_map_set",
  "Grm::DBIC::Maps::Result::GermplasmToMapSet",
  { "foreign.map_set_id" => "self.map_set_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 maps

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Map>

=cut

__PACKAGE__->has_many(
  "maps",
  "Grm::DBIC::Maps::Result::Map",
  { "foreign.map_set_id" => "self.map_set_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 map_type

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::MapType>

=cut

__PACKAGE__->belongs_to(
  "map_type",
  "Grm::DBIC::Maps::Result::MapType",
  { map_type_id => "map_type_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-11-14 16:11:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GYvH+STv6FaGMnkI81TZag


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
