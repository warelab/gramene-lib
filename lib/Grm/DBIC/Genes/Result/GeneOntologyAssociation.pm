package Grm::DBIC::Genes::Result::GeneOntologyAssociation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneOntologyAssociation

=cut

__PACKAGE__->table("gene_ontology_association");

=head1 ACCESSORS

=head2 ontology_association_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 object_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 object_table

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 term_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 term_type

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "ontology_association_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "object_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "object_table",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "term_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "term_type",
  { data_type => "varchar", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("ontology_association_id");
__PACKAGE__->add_unique_constraint("object_id", ["object_id", "object_table", "term_accession"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1RAKOxo3LNciJ+g2Z6WeZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
