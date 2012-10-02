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
__PACKAGE__->add_unique_constraint("cs_table_name_idx", ["coord_system_id", "table_name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lTeDiERUGaqy6KBQSNZLHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
