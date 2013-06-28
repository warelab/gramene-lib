package Grm::DBIC::Genes::Result::GeneGeneInteractionEvidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneInteractionEvidence

=cut

__PACKAGE__->table("gene_gene_interaction_evidence");

=head1 ACCESSORS

=head2 gene_interaction_evidence_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene_interaction_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 evidence_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 dbxref_to_object_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gene_interaction_evidence_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene_interaction_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "evidence_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "dbxref_to_object_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "comment",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("gene_interaction_evidence_id");

=head1 RELATIONS

=head2 gene_interaction

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGeneInteraction>

=cut

__PACKAGE__->belongs_to(
  "gene_interaction",
  "Grm::DBIC::Genes::Result::GeneGeneInteraction",
  { gene_interaction_id => "gene_interaction_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NAmAfJ3jUkz+IoVQHLutBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
