package Grm::DBIC::Compara::Result::Homology;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::Homology

=cut

__PACKAGE__->table("homology");

=head1 ACCESSORS

=head2 homology_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 method_link_species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 description

  data_type: 'enum'
  extra: {list => ["ortholog_one2one","apparent_ortholog_one2one","ortholog_one2many","ortholog_many2many","within_species_paralog","other_paralog","putative_gene_split","contiguous_gene_split","between_species_paralog","possible_ortholog","UBRH","BRH","MBRH","RHS","projection_unchanged","projection_altered"]}
  is_nullable: 1

=head2 subtype

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 40

=head2 dn

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 ds

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 n

  data_type: 'float'
  is_nullable: 1
  size: [10,1]

=head2 s

  data_type: 'float'
  is_nullable: 1
  size: [10,1]

=head2 lnl

  data_type: 'float'
  is_nullable: 1
  size: [10,3]

=head2 threshold_on_ds

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 ancestor_node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 tree_node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "homology_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "method_link_species_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "description",
  {
    data_type => "enum",
    extra => {
      list => [
        "ortholog_one2one",
        "apparent_ortholog_one2one",
        "ortholog_one2many",
        "ortholog_many2many",
        "within_species_paralog",
        "other_paralog",
        "putative_gene_split",
        "contiguous_gene_split",
        "between_species_paralog",
        "possible_ortholog",
        "UBRH",
        "BRH",
        "MBRH",
        "RHS",
        "projection_unchanged",
        "projection_altered",
      ],
    },
    is_nullable => 1,
  },
  "subtype",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 40 },
  "dn",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "ds",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "n",
  { data_type => "float", is_nullable => 1, size => [10, 1] },
  "s",
  { data_type => "float", is_nullable => 1, size => [10, 1] },
  "lnl",
  { data_type => "float", is_nullable => 1, size => [10, 3] },
  "threshold_on_ds",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "ancestor_node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "tree_node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("homology_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8SG69beGtZjyFJi2NR29jg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
