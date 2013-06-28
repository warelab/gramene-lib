package Grm::DBIC::Genes::Result::GeneGeneInteraction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneInteraction

=cut

__PACKAGE__->table("gene_gene_interaction");

=head1 ACCESSORS

=head2 gene_interaction_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene1_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene1_object_class

  data_type: 'varchar'
  default_value: 'Gene'
  is_nullable: 0
  size: 32

=head2 gene_interaction_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 gene2_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene2_object_class

  data_type: 'varchar'
  default_value: 'Gene'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "gene_interaction_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene1_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene1_object_class",
  {
    data_type => "varchar",
    default_value => "Gene",
    is_nullable => 0,
    size => 32,
  },
  "gene_interaction_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "gene2_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene2_object_class",
  {
    data_type => "varchar",
    default_value => "Gene",
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("gene_interaction_id");
__PACKAGE__->add_unique_constraint(
  "gene1_id",
  [
    "gene1_id",
    "gene1_object_class",
    "gene_interaction_type_id",
    "gene2_id",
    "gene2_object_class",
  ],
);

=head1 RELATIONS

=head2 gene_interaction_type

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGeneInteractionType>

=cut

__PACKAGE__->belongs_to(
  "gene_interaction_type",
  "Grm::DBIC::Genes::Result::GeneGeneInteractionType",
  { gene_interaction_type_id => "gene_interaction_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 gene_gene_interaction_evidences

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGeneInteractionEvidence>

=cut

__PACKAGE__->has_many(
  "gene_gene_interaction_evidences",
  "Grm::DBIC::Genes::Result::GeneGeneInteractionEvidence",
  { "foreign.gene_interaction_id" => "self.gene_interaction_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fBcb/MYxndxglpZ5kP0N8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
