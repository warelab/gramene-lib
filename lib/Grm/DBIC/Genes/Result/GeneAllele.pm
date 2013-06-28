package Grm::DBIC::Genes::Result::GeneAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneAllele

=cut

__PACKAGE__->table("gene_allele");

=head1 ACCESSORS

=head2 allele_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 symbol

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 allele_interaction_description

  data_type: 'text'
  is_nullable: 1

=head2 public_curation_comment

  data_type: 'text'
  is_nullable: 1

=head2 internal_curation_comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "allele_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "symbol",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "allele_interaction_description",
  { data_type => "text", is_nullable => 1 },
  "public_curation_comment",
  { data_type => "text", is_nullable => 1 },
  "internal_curation_comment",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("allele_id");
__PACKAGE__->add_unique_constraint("symbol", ["symbol"]);
__PACKAGE__->add_unique_constraint("accession", ["accession"]);

=head1 RELATIONS

=head2 gene_allele_synonyms

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneAlleleSynonym>

=cut

__PACKAGE__->has_many(
  "gene_allele_synonyms",
  "Grm::DBIC::Genes::Result::GeneAlleleSynonym",
  { "foreign.allele_id" => "self.allele_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_gene_to_alleles

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGeneToAllele>

=cut

__PACKAGE__->has_many(
  "gene_gene_to_alleles",
  "Grm::DBIC::Genes::Result::GeneGeneToAllele",
  { "foreign.allele_id" => "self.allele_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g5NHv4fxgZ+WcOsjjqvv0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
