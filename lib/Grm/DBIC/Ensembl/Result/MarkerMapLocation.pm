package Grm::DBIC::Ensembl::Result::MarkerMapLocation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MarkerMapLocation

=cut

__PACKAGE__->table("marker_map_location");

=head1 ACCESSORS

=head2 marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 map_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 chromosome_name

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=head2 marker_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 position

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=head2 lod_score

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "marker_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "map_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "chromosome_name",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "marker_synonym_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "position",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "lod_score",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("marker_id", "map_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qeMhz076F6d6LyvyHgGhxQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
