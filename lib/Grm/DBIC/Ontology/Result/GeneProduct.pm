package Grm::DBIC::Ontology::Result::GeneProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::GeneProduct

=cut

__PACKAGE__->table("gene_product");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_product_symbol

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 organism_dbxref_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 gene_product_full_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "gene_product_symbol",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "organism_dbxref_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "species_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "gene_product_full_name",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("gene_product_id");
__PACKAGE__->add_unique_constraint(
  "gene_product_symbol",
  ["gene_product_symbol", "organism_dbxref_id"],
);

=head1 RELATIONS

=head2 organism_dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "organism_dbxref",
  "Grm::DBIC::Ontology::Result::Dbxref",
  { dbxref_id => "organism_dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Ontology::Result::Species",
  { species_id => "species_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 gene_product_synonyms

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::GeneProductSynonym>

=cut

__PACKAGE__->has_many(
  "gene_product_synonyms",
  "Grm::DBIC::Ontology::Result::GeneProductSynonym",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bSURYHT7Mro5R0ba6O3tBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
