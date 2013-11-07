use utf8;
package Grm::DBIC::Ensembl::Result::Map;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Map

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<map>

=cut

__PACKAGE__->table("map");

=head1 ACCESSORS

=head2 map_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 map_name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "map_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "map_name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
);

=head1 PRIMARY KEY

=over 4

=item * L</map_id>

=back

=cut

__PACKAGE__->set_primary_key("map_id");

=head1 RELATIONS

=head2 marker_map_locations

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerMapLocation>

=cut

__PACKAGE__->has_many(
  "marker_map_locations",
  "Grm::DBIC::Ensembl::Result::MarkerMapLocation",
  { "foreign.map_id" => "self.map_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Rg2ijCH658TjiBQP63KA1A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
