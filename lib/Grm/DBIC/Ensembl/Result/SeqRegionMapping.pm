use utf8;
package Grm::DBIC::Ensembl::Result::SeqRegionMapping;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::SeqRegionMapping

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_region_mapping>

=cut

__PACKAGE__->table("seq_region_mapping");

=head1 ACCESSORS

=head2 seq_region_mapping_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 external_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 internal_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 mapping_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "seq_region_mapping_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "external_seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "internal_seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "mapping_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_region_mapping_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_region_mapping_id");

=head1 RELATIONS

=head2 internal_seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "internal_seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "internal_seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 mapping_set

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MappingSet>

=cut

__PACKAGE__->belongs_to(
  "mapping_set",
  "Grm::DBIC::Ensembl::Result::MappingSet",
  { mapping_set_id => "mapping_set_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4Q9Gb5yLCtb194MPD0LDfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
