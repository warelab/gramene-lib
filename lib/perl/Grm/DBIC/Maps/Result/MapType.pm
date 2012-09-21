package Grm::DBIC::Maps::Result::MapType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::MapType

=cut

__PACKAGE__->table("map_type");

=head1 ACCESSORS

=head2 map_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 map_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "map_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "map_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("map_type_id");
__PACKAGE__->add_unique_constraint("map_type", ["map_type"]);

=head1 RELATIONS

=head2 map_sets

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::MapSet>

=cut

__PACKAGE__->has_many(
  "map_sets",
  "Grm::DBIC::Maps::Result::MapSet",
  { "foreign.map_type_id" => "self.map_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oYA6aZmXxiFKuKfElQK3jg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
