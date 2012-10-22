package Grm::DBIC::Ensembl::Result::MappingSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MappingSet

=cut

__PACKAGE__->table("mapping_set");

=head1 ACCESSORS

=head2 mapping_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 schema_build

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "mapping_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "schema_build",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("mapping_set_id");

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YxpduoOuHwwoflsyieJhog


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
