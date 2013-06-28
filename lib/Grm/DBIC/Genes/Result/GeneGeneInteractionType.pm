package Grm::DBIC::Genes::Result::GeneGeneInteractionType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneInteractionType

=cut

__PACKAGE__->table("gene_gene_interaction_type");

=head1 ACCESSORS

=head2 gene_interaction_type_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 interaction_type

  data_type: 'varchar'
  default_value: 'interacts'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "gene_interaction_type_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "interaction_type",
  {
    data_type => "varchar",
    default_value => "interacts",
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("gene_interaction_type_id");
__PACKAGE__->add_unique_constraint("interaction_type", ["interaction_type"]);

=head1 RELATIONS

=head2 gene_gene_interactions

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGeneInteraction>

=cut

__PACKAGE__->has_many(
  "gene_gene_interactions",
  "Grm::DBIC::Genes::Result::GeneGeneInteraction",
  {
    "foreign.gene_interaction_type_id" => "self.gene_interaction_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3QjQE0jkTAxAAp0vMqIIzg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
