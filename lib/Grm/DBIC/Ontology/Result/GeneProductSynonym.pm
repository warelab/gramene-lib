package Grm::DBIC::Ontology::Result::GeneProductSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::GeneProductSynonym

=cut

__PACKAGE__->table("gene_product_synonym");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 gene_product_synonym_symbol

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "gene_product_synonym_symbol",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->add_unique_constraint(
  "gene_product_id_2",
  ["gene_product_id", "gene_product_synonym_symbol"],
);

=head1 RELATIONS

=head2 gene_product

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::GeneProduct>

=cut

__PACKAGE__->belongs_to(
  "gene_product",
  "Grm::DBIC::Ontology::Result::GeneProduct",
  { gene_product_id => "gene_product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:51mK4cnBNo4XQvaoebiK5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;