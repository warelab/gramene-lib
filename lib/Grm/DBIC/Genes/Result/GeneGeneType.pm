package Grm::DBIC::Genes::Result::GeneGeneType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneType

=cut

__PACKAGE__->table("gene_gene_type");

=head1 ACCESSORS

=head2 gene_type_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=cut

__PACKAGE__->add_columns(
  "gene_type_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("gene_type_id");
__PACKAGE__->add_unique_constraint("gene_type", ["gene_type"]);

=head1 RELATIONS

=head2 gene_genes

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGene>

=cut

__PACKAGE__->has_many(
  "gene_genes",
  "Grm::DBIC::Genes::Result::GeneGene",
  { "foreign.gene_type_id" => "self.gene_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mbUsJhkCPyEmAzR286ek5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
