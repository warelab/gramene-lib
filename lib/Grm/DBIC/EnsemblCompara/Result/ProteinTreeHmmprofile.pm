package Grm::DBIC::EnsemblCompara::Result::ProteinTreeHmmprofile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::ProteinTreeHmmprofile

=cut

__PACKAGE__->table("protein_tree_hmmprofile");

=head1 ACCESSORS

=head2 node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 40

=head2 hmmprofile

  data_type: 'mediumtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 40 },
  "hmmprofile",
  { data_type => "mediumtext", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("type_node_id", ["type", "node_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NXMKpqnqAbj+Jb7SxU3YFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
