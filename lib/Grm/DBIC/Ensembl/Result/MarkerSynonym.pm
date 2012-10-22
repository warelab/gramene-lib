package Grm::DBIC::Ensembl::Result::MarkerSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MarkerSynonym

=cut

__PACKAGE__->table("marker_synonym");

=head1 ACCESSORS

=head2 marker_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "marker_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("marker_synonym_id");

=head1 RELATIONS

=head2 markers

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->has_many(
  "markers",
  "Grm::DBIC::Ensembl::Result::Marker",
  { "foreign.display_marker_synonym_id" => "self.marker_synonym_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 marker_map_locations

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerMapLocation>

=cut

__PACKAGE__->has_many(
  "marker_map_locations",
  "Grm::DBIC::Ensembl::Result::MarkerMapLocation",
  { "foreign.marker_synonym_id" => "self.marker_synonym_id" },
  { cascade_copy => 0, cascade_delete => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fUpof+hQqHUD9Rp198r75w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
