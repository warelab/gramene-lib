package Grm::DBIC::EnsemblCompara::Result::GenomicAlignTree;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::GenomicAlignTree

=cut

__PACKAGE__->table("genomic_align_tree");

=head1 ACCESSORS

=head2 node_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 parent_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 root_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 left_index

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 right_index

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 left_node_id

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=head2 right_node_id

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=head2 distance_to_parent

  data_type: 'double precision'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "node_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "parent_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "root_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "left_index",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "right_index",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "left_node_id",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
  "right_node_id",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
  "distance_to_parent",
  { data_type => "double precision", default_value => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("node_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bHapB9HKX4opaaFiyk/+jQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
