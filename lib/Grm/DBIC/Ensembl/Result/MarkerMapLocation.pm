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
  is_foreign_key: 1
  is_nullable: 0

=head2 map_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 chromosome_name

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=head2 marker_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "map_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "chromosome_name",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "marker_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "position",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "lod_score",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("marker_id", "map_id");

=head1 RELATIONS

=head2 map

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Map>

=cut

__PACKAGE__->belongs_to(
  "map",
  "Grm::DBIC::Ensembl::Result::Map",
  { map_id => "map_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 marker

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->belongs_to(
  "marker",
  "Grm::DBIC::Ensembl::Result::Marker",
  { marker_id => "marker_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 marker_synonym

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MarkerSynonym>

=cut

__PACKAGE__->belongs_to(
  "marker_synonym",
  "Grm::DBIC::Ensembl::Result::MarkerSynonym",
  { marker_synonym_id => "marker_synonym_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EsffFV04kb3GC7AJEpvG3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
