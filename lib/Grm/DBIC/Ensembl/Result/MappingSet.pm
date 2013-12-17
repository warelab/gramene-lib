use utf8;
package Grm::DBIC::Ensembl::Result::MappingSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MappingSet

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<mapping_set>

=cut

__PACKAGE__->table("mapping_set");

=head1 ACCESSORS

=head2 mapping_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 internal_schema_build

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 external_schema_build

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "mapping_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "internal_schema_build",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "external_schema_build",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mapping_set_id>

=back

=cut

__PACKAGE__->set_primary_key("mapping_set_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<mapping_idx>

=over 4

=item * L</internal_schema_build>

=item * L</external_schema_build>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "mapping_idx",
  ["internal_schema_build", "external_schema_build"],
);

=head1 RELATIONS

=head2 seq_region_mappings

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegionMapping>

=cut

__PACKAGE__->has_many(
  "seq_region_mappings",
  "Grm::DBIC::Ensembl::Result::SeqRegionMapping",
  { "foreign.mapping_set_id" => "self.mapping_set_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MwfaBo31a+FZqsAhXCN1tQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
