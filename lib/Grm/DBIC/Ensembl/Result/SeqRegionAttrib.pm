use utf8;
package Grm::DBIC::Ensembl::Result::SeqRegionAttrib;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::SeqRegionAttrib

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_region_attrib>

=cut

__PACKAGE__->table("seq_region_attrib");

=head1 ACCESSORS

=head2 seq_region_attrib_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 attrib_type_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "seq_region_attrib_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "attrib_type_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "value",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_region_attrib_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_region_attrib_id");

=head1 RELATIONS

=head2 attrib_type

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::AttribType>

=cut

__PACKAGE__->belongs_to(
  "attrib_type",
  "Grm::DBIC::Ensembl::Result::AttribType",
  { attrib_type_id => "attrib_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KifXDt10Qix7mx+gMO0+tA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
