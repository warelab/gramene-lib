use utf8;
package Grm::DBIC::Ensembl::Result::Qtl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Qtl

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<qtl>

=cut

__PACKAGE__->table("qtl");

=head1 ACCESSORS

=head2 qtl_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 trait

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 lod_score

  data_type: 'float'
  is_nullable: 1

=head2 flank_marker_id_1

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 flank_marker_id_2

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 peak_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "qtl_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "trait",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "lod_score",
  { data_type => "float", is_nullable => 1 },
  "flank_marker_id_1",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "flank_marker_id_2",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "peak_marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</qtl_id>

=back

=cut

__PACKAGE__->set_primary_key("qtl_id");

=head1 RELATIONS

=head2 flank_marker_id_1

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->belongs_to(
  "flank_marker_id_1",
  "Grm::DBIC::Ensembl::Result::Marker",
  { marker_id => "flank_marker_id_1" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 flank_marker_id_2

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->belongs_to(
  "flank_marker_id_2",
  "Grm::DBIC::Ensembl::Result::Marker",
  { marker_id => "flank_marker_id_2" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 peak_marker

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Marker>

=cut

__PACKAGE__->belongs_to(
  "peak_marker",
  "Grm::DBIC::Ensembl::Result::Marker",
  { marker_id => "peak_marker_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 qtl_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::QtlFeature>

=cut

__PACKAGE__->has_many(
  "qtl_features",
  "Grm::DBIC::Ensembl::Result::QtlFeature",
  { "foreign.qtl_id" => "self.qtl_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_synonyms

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::QtlSynonym>

=cut

__PACKAGE__->has_many(
  "qtl_synonyms",
  "Grm::DBIC::Ensembl::Result::QtlSynonym",
  { "foreign.qtl_id" => "self.qtl_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+ZrxlmOjSO9lE0JEPH7c8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
