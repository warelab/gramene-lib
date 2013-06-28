package Grm::DBIC::Protein::Result::GeneProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::GeneProduct

=cut

__PACKAGE__->table("gene_product");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
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
  { data_type => "integer", default_value => 0, is_nullable => 0 },
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

=head2 associations

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::Association>

=cut

__PACKAGE__->has_many(
  "associations",
  "Grm::DBIC::Protein::Result::Association",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 expressions

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::Expression>

=cut

__PACKAGE__->has_many(
  "expressions",
  "Grm::DBIC::Protein::Result::Expression",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Protein::Result::Species",
  { species_id => "species_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 organism_dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "organism_dbxref",
  "Grm::DBIC::Protein::Result::Dbxref",
  { dbxref_id => "organism_dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 gene_product_comment

Type: might_have

Related object: L<Grm::DBIC::Protein::Result::GeneProductComment>

=cut

__PACKAGE__->might_have(
  "gene_product_comment",
  "Grm::DBIC::Protein::Result::GeneProductComment",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_features

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductFeature>

=cut

__PACKAGE__->has_many(
  "gene_product_features",
  "Grm::DBIC::Protein::Result::GeneProductFeature",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_gene_names

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductGeneName>

=cut

__PACKAGE__->has_many(
  "gene_product_gene_names",
  "Grm::DBIC::Protein::Result::GeneProductGeneName",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_helper

Type: might_have

Related object: L<Grm::DBIC::Protein::Result::GeneProductHelper>

=cut

__PACKAGE__->might_have(
  "gene_product_helper",
  "Grm::DBIC::Protein::Result::GeneProductHelper",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_organelles

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductOrganelle>

=cut

__PACKAGE__->has_many(
  "gene_product_organelles",
  "Grm::DBIC::Protein::Result::GeneProductOrganelle",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_prosites

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductProsite>

=cut

__PACKAGE__->has_many(
  "gene_product_prosites",
  "Grm::DBIC::Protein::Result::GeneProductProsite",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_seqs

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductSeq>

=cut

__PACKAGE__->has_many(
  "gene_product_seqs",
  "Grm::DBIC::Protein::Result::GeneProductSeq",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_synonyms

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductSynonym>

=cut

__PACKAGE__->has_many(
  "gene_product_synonyms",
  "Grm::DBIC::Protein::Result::GeneProductSynonym",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_tissues

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductTissue>

=cut

__PACKAGE__->has_many(
  "gene_product_tissues",
  "Grm::DBIC::Protein::Result::GeneProductTissue",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_cultivars

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToCultivar>

=cut

__PACKAGE__->has_many(
  "gene_product_to_cultivars",
  "Grm::DBIC::Protein::Result::GeneProductToCultivar",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_embl_accessions

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToEmblAccession>

=cut

__PACKAGE__->has_many(
  "gene_product_to_embl_accessions",
  "Grm::DBIC::Protein::Result::GeneProductToEmblAccession",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_gi_numbers

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToGiNumber>

=cut

__PACKAGE__->has_many(
  "gene_product_to_gi_numbers",
  "Grm::DBIC::Protein::Result::GeneProductToGiNumber",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_keywords

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToKeyword>

=cut

__PACKAGE__->has_many(
  "gene_product_to_keywords",
  "Grm::DBIC::Protein::Result::GeneProductToKeyword",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_pids

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToPid>

=cut

__PACKAGE__->has_many(
  "gene_product_to_pids",
  "Grm::DBIC::Protein::Result::GeneProductToPid",
  { "foreign.gene_product_id" => "self.gene_product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:55:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:20ASx4bvlt82Z7FotQrjJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
