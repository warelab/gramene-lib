package Grm::DBIC::Ensembl::Result::Marker;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Marker

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
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
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

=head2 qtl_flank_marker_id_1s

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Qtl>

=cut

__PACKAGE__->has_many(
  "qtl_flank_marker_id_1s",
  "Grm::DBIC::Ensembl::Result::Qtl",
  { "foreign.flank_marker_id_1" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_flank_marker_id_2s

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Qtl>

=cut

__PACKAGE__->has_many(
  "qtl_flank_marker_id_2s",
  "Grm::DBIC::Ensembl::Result::Qtl",
  { "foreign.flank_marker_id_2" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_peak_markers

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Qtl>

=cut

__PACKAGE__->has_many(
  "qtl_peak_markers",
  "Grm::DBIC::Ensembl::Result::Qtl",
  { "foreign.peak_marker_id" => "self.marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jcqTv20g8u5fJ2cc1GGKRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
