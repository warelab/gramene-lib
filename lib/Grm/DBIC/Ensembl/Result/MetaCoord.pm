package Grm::DBIC::Ensembl::Result::MetaCoord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MetaCoord

=cut

__PACKAGE__->table("meta_coord");

=head1 ACCESSORS

=head2 meta_coord_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

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
  "meta_coord_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
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
__PACKAGE__->set_primary_key("meta_coord_id");
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
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FVxRhVSFRoDbfIRMqfIpAg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
