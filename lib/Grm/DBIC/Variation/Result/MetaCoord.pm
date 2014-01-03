use utf8;
package Grm::DBIC::Variation::Result::MetaCoord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::MetaCoord

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
  is_nullable: 0

=head2 max_length

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "table_name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "coord_system_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "max_length",
  { data_type => "integer", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<table_name>

=over 4

=item * L</table_name>

=item * L</coord_system_id>

=back

=cut

__PACKAGE__->add_unique_constraint("table_name", ["table_name", "coord_system_id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZnlOLT1ixcd395Rcy42Rdw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
