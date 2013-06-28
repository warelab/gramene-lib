package Grm::DBIC::Genes::Result::GeneGeneToAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneToAllele

=cut

__PACKAGE__->table("gene_gene_to_allele");

=head1 ACCESSORS

=head2 gene_to_allele_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 allele_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_to_allele_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "gene_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "allele_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);
__PACKAGE__->set_primary_key("gene_to_allele_id");
__PACKAGE__->add_unique_constraint("gene_id", ["gene_id", "allele_id"]);

=head1 RELATIONS

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Genes::Result::GeneGene",
  { gene_id => "gene_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 allele

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneAllele>

=cut

__PACKAGE__->belongs_to(
  "allele",
  "Grm::DBIC::Genes::Result::GeneAllele",
  { allele_id => "allele_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e8keeQ1/+eR62cp7GrmNtg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
