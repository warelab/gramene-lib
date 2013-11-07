use utf8;
package Grm::DBIC::Ensembl::Result::CoordSystem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::CoordSystem

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<coord_system>

=cut

__PACKAGE__->table("coord_system");

=head1 ACCESSORS

=head2 coord_system_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 version

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 rank

  data_type: 'integer'
  is_nullable: 0

=head2 attrib

  data_type: 'set'
  extra: {list => ["default_version","sequence_level"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "coord_system_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "species_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "version",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "rank",
  { data_type => "integer", is_nullable => 0 },
  "attrib",
  {
    data_type => "set",
    extra => { list => ["default_version", "sequence_level"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</coord_system_id>

=back

=cut

__PACKAGE__->set_primary_key("coord_system_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_idx>

=over 4

=item * L</name>

=item * L</version>

=item * L</species_id>

=back

=cut

__PACKAGE__->add_unique_constraint("name_idx", ["name", "version", "species_id"]);

=head2 C<rank_idx>

=over 4

=item * L</rank>

=item * L</species_id>

=back

=cut

__PACKAGE__->add_unique_constraint("rank_idx", ["rank", "species_id"]);

=head1 RELATIONS

=head2 data_files

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DataFile>

=cut

__PACKAGE__->has_many(
  "data_files",
  "Grm::DBIC::Ensembl::Result::DataFile",
  { "foreign.coord_system_id" => "self.coord_system_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 meta_coords

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MetaCoord>

=cut

__PACKAGE__->has_many(
  "meta_coords",
  "Grm::DBIC::Ensembl::Result::MetaCoord",
  { "foreign.coord_system_id" => "self.coord_system_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_regions

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->has_many(
  "seq_regions",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { "foreign.coord_system_id" => "self.coord_system_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EmO7heuLEcSF6R9Zf/6DBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
