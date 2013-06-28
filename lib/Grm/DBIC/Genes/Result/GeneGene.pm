package Grm::DBIC::Genes::Result::GeneGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGene

=cut

__PACKAGE__->table("gene_gene");

=head1 ACCESSORS

=head2 gene_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 symbol

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 species_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 gene_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 chromosome

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 description

  data_type: 'text'
  is_nullable: 0

=head2 public_curation_comment

  data_type: 'text'
  is_nullable: 1

=head2 internal_curation_comment

  data_type: 'text'
  is_nullable: 1

=head2 has_phenotype

  data_type: 'enum'
  default_value: 'not curated'
  extra: {list => ["yes","no","not curated"]}
  is_nullable: 0

=head2 is_obsolete

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "symbol",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "species_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "gene_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "chromosome",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "description",
  { data_type => "text", is_nullable => 0 },
  "public_curation_comment",
  { data_type => "text", is_nullable => 1 },
  "internal_curation_comment",
  { data_type => "text", is_nullable => 1 },
  "has_phenotype",
  {
    data_type => "enum",
    default_value => "not curated",
    extra => { list => ["yes", "no", "not curated"] },
    is_nullable => 0,
  },
  "is_obsolete",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("gene_id");
__PACKAGE__->add_unique_constraint("accession", ["accession"]);

=head1 RELATIONS

=head2 gene_type

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGeneType>

=cut

__PACKAGE__->belongs_to(
  "gene_type",
  "Grm::DBIC::Genes::Result::GeneGeneType",
  { gene_type_id => "gene_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneSpecies>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Genes::Result::GeneSpecies",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 gene_gene_synonyms

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGeneSynonym>

=cut

__PACKAGE__->has_many(
  "gene_gene_synonyms",
  "Grm::DBIC::Genes::Result::GeneGeneSynonym",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_gene_to_alleles

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGeneToAllele>

=cut

__PACKAGE__->has_many(
  "gene_gene_to_alleles",
  "Grm::DBIC::Genes::Result::GeneGeneToAllele",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_map_positions

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneMapPosition>

=cut

__PACKAGE__->has_many(
  "gene_map_positions",
  "Grm::DBIC::Genes::Result::GeneMapPosition",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bGCeWeCIYacnXEzS807Opw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
