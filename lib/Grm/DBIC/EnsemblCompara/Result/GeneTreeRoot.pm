package Grm::DBIC::EnsemblCompara::Result::GeneTreeRoot;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::GeneTreeRoot

=cut

__PACKAGE__->table("gene_tree_root");

=head1 ACCESSORS

=head2 root_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 member_type

  data_type: 'enum'
  extra: {list => ["protein","ncrna"]}
  is_nullable: 0

=head2 tree_type

  data_type: 'enum'
  extra: {list => ["clusterset","supertree","tree"]}
  is_nullable: 0

=head2 clusterset_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 method_link_species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 version

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "root_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "member_type",
  {
    data_type => "enum",
    extra => { list => ["protein", "ncrna"] },
    is_nullable => 0,
  },
  "tree_type",
  {
    data_type => "enum",
    extra => { list => ["clusterset", "supertree", "tree"] },
    is_nullable => 0,
  },
  "clusterset_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "method_link_species_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "version",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("root_id");
__PACKAGE__->add_unique_constraint("stable_id", ["stable_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T97Jv2ZDirwLLC+PZmAK/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
