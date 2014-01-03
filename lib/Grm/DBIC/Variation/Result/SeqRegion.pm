use utf8;
package Grm::DBIC::Variation::Result::SeqRegion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::SeqRegion

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_region>

=cut

__PACKAGE__->table("seq_region");

=head1 ACCESSORS

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 coord_system_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "coord_system_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_region_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_region_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_cs_idx>

=over 4

=item * L</name>

=item * L</coord_system_id>

=back

=cut

__PACKAGE__->add_unique_constraint("name_cs_idx", ["name", "coord_system_id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3EUh3D+p+0NwNgMvjPqWXw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
