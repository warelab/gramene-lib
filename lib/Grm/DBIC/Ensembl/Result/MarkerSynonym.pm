use utf8;
package Grm::DBIC::Ensembl::Result::MarkerSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MarkerSynonym

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<marker_synonym>

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

=head1 PRIMARY KEY

=over 4

=item * L</marker_synonym_id>

=back

=cut

__PACKAGE__->set_primary_key("marker_synonym_id");

=head1 RELATIONS

=head2 marker

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->belongs_to(
  "marker",
  "Grm::DBIC::Ensembl::Result::Marker",
  { marker_id => "marker_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 16:58:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zCCra2w13jiXHBiDFW258g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
