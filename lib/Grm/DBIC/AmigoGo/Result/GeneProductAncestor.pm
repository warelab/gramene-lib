package Grm::DBIC::AmigoGo::Result::GeneProductAncestor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoGo::Result::GeneProductAncestor

=cut

__PACKAGE__->table("gene_product_ancestor");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 ancestor_id

  data_type: 'integer'
  is_nullable: 0

=head2 phylotree_id

  data_type: 'integer'
  is_nullable: 0

=head2 branch_length

  data_type: 'float'
  is_nullable: 1

=head2 is_transitive

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "ancestor_id",
  { data_type => "integer", is_nullable => 0 },
  "phylotree_id",
  { data_type => "integer", is_nullable => 0 },
  "branch_length",
  { data_type => "float", is_nullable => 1 },
  "is_transitive",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->add_unique_constraint(
  "gene_product_id",
  ["gene_product_id", "ancestor_id", "phylotree_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KicYsUQ85cvnYOv5dARNVg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
