package Grm::DBIC::Compara::Result::GeneTreeNodeAttr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::GeneTreeNodeAttr

=cut

__PACKAGE__->table("gene_tree_node_attr");

=head1 ACCESSORS

=head2 node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 node_type

  data_type: 'enum'
  extra: {list => ["duplication","dubious","speciation","gene_split"]}
  is_nullable: 1

=head2 taxon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 taxon_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 bootstrap

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 duplication_confidence_score

  data_type: 'double precision'
  is_nullable: 1
  size: [5,4]

=head2 tree_support

  data_type: 'set'
  extra: {list => ["phyml_nt","nj_ds","phyml_aa","nj_dn","nj_mm","quicktree"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "node_type",
  {
    data_type => "enum",
    extra => { list => ["duplication", "dubious", "speciation", "gene_split"] },
    is_nullable => 1,
  },
  "taxon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "taxon_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "bootstrap",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "duplication_confidence_score",
  { data_type => "double precision", is_nullable => 1, size => [5, 4] },
  "tree_support",
  {
    data_type => "set",
    extra => {
      list => ["phyml_nt", "nj_ds", "phyml_aa", "nj_dn", "nj_mm", "quicktree"],
    },
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("node_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0eNQKlxAIENsGUnsfWZ2gg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
