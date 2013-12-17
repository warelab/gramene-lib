use utf8;
package Grm::DBIC::Ensembl::Result::Marker;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Marker

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<marker>

=cut

__PACKAGE__->table("marker");

=head1 ACCESSORS

=head2 marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 display_marker_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 left_primer

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 right_primer

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 min_primer_dist

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 max_primer_dist

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 priority

  data_type: 'integer'
  is_nullable: 1

=head2 type

  data_type: 'enum'
  extra: {list => ["est","microsatellite"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "display_marker_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "left_primer",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "right_primer",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "min_primer_dist",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "max_primer_dist",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "priority",
  { data_type => "integer", is_nullable => 1 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["est", "microsatellite"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</marker_id>

=back

=cut

__PACKAGE__->set_primary_key("marker_id");

=head1 RELATIONS

=head2 display_marker_synonym

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MarkerSynonym>

=cut

__PACKAGE__->belongs_to(
  "display_marker_synonym",
  "Grm::DBIC::Ensembl::Result::MarkerSynonym",
  { marker_synonym_id => "display_marker_synonym_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 marker_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerFeature>

=cut

__PACKAGE__->has_many(
  "marker_features",
  "Grm::DBIC::Ensembl::Result::MarkerFeature",
  { "foreign.marker_id" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 marker_map_locations

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerMapLocation>

=cut

__PACKAGE__->has_many(
  "marker_map_locations",
  "Grm::DBIC::Ensembl::Result::MarkerMapLocation",
  { "foreign.marker_id" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 marker_synonyms

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerSynonym>

=cut

__PACKAGE__->has_many(
  "marker_synonyms",
  "Grm::DBIC::Ensembl::Result::MarkerSynonym",
  { "foreign.marker_id" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8bBDwBfPuqe/BcIzyLrWcw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
