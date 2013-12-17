use utf8;
package Grm::DBIC::Ensembl::Result::MetaCoord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MetaCoord

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<meta_coord>

=cut

__PACKAGE__->table("meta_coord");

=head1 ACCESSORS

=head2 table_name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 coord_system_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 max_length

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "table_name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "coord_system_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "max_length",
  { data_type => "integer", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<cs_table_name_idx>

=over 4

=item * L</coord_system_id>

=item * L</table_name>

=back

=cut

__PACKAGE__->add_unique_constraint("cs_table_name_idx", ["coord_system_id", "table_name"]);

=head1 RELATIONS

=head2 coord_system

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::CoordSystem>

=cut

__PACKAGE__->belongs_to(
  "coord_system",
  "Grm::DBIC::Ensembl::Result::CoordSystem",
  { coord_system_id => "coord_system_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I2Ov18HUoS5LxULRt13Dgw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
