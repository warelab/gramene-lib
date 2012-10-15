package Grm::DBIC::EnsemblCompara::Result::LrIndexOffset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::LrIndexOffset

=cut

__PACKAGE__->table("lr_index_offset");

=head1 ACCESSORS

=head2 lr_index_offset_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 lr_index

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "lr_index_offset_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "table_name",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "lr_index",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("lr_index_offset_id");
__PACKAGE__->add_unique_constraint("table_name", ["table_name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nBnfXPY5q9clAzwHMQ4Eog


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
