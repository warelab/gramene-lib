package Grm::DBIC::Maps::Result::Map;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::Map

=cut

__PACKAGE__->table("map");

=head1 ACCESSORS

=head2 map_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 map_set_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 map_acc

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 30

=head2 map_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 display_order

  data_type: 'smallint'
  default_value: 0
  is_nullable: 0

=head2 start

  data_type: 'double precision'
  default_value: 0.00
  is_nullable: 0

=head2 end

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "map_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "map_set_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "map_acc",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 30 },
  "map_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "display_order",
  { data_type => "smallint", default_value => 0, is_nullable => 0 },
  "start",
  {
    data_type     => "double precision",
    default_value => "0.00",
    is_nullable   => 0,
  },
  "end",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("map_id");
__PACKAGE__->add_unique_constraint("map_acc", ["map_acc"]);

=head1 RELATIONS

=head2 map_set

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::MapSet>

=cut

__PACKAGE__->belongs_to(
  "map_set",
  "Grm::DBIC::Maps::Result::MapSet",
  { map_set_id => "map_set_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 mappings

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Mapping>

=cut

__PACKAGE__->has_many(
  "mappings",
  "Grm::DBIC::Maps::Result::Mapping",
  { "foreign.map_id" => "self.map_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fz4uiVOsBRhgTv4Hm+1cKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
