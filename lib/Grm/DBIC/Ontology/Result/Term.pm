package Grm::DBIC::Ontology::Result::Term;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::Term

=cut

__PACKAGE__->table("term");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 term_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 is_obsolete

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 is_root

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "term_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "is_obsolete",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "is_root",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_id");
__PACKAGE__->add_unique_constraint("term_type", ["term_type_id", "term_accession"]);

=head1 RELATIONS

=head2 associations

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::Association>

=cut

__PACKAGE__->has_many(
  "associations",
  "Grm::DBIC::Ontology::Result::Association",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 graph_path_term1s

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::GraphPath>

=cut

__PACKAGE__->has_many(
  "graph_path_term1s",
  "Grm::DBIC::Ontology::Result::GraphPath",
  { "foreign.term1_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 graph_path_term2s

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::GraphPath>

=cut

__PACKAGE__->has_many(
  "graph_path_term2s",
  "Grm::DBIC::Ontology::Result::GraphPath",
  { "foreign.term2_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 graph_path_to_terms

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::GraphPathToTerm>

=cut

__PACKAGE__->has_many(
  "graph_path_to_terms",
  "Grm::DBIC::Ontology::Result::GraphPathToTerm",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 object_association_counts

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::ObjectAssociationCount>

=cut

__PACKAGE__->has_many(
  "object_association_counts",
  "Grm::DBIC::Ontology::Result::ObjectAssociationCount",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 quick_terms_to_object

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::QuickTermToObject>

=cut

__PACKAGE__->has_many(
  "quick_terms_to_object",
  "Grm::DBIC::Ontology::Result::QuickTermToObject",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_type

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::TermType>

=cut

__PACKAGE__->belongs_to(
  "term_type",
  "Grm::DBIC::Ontology::Result::TermType",
  { term_type_id => "term_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 term_dbxrefs

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::TermDbxref>

=cut

__PACKAGE__->has_many(
  "term_dbxrefs",
  "Grm::DBIC::Ontology::Result::TermDbxref",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_definition

Type: might_have

Related object: L<Grm::DBIC::Ontology::Result::TermDefinition>

=cut

__PACKAGE__->might_have(
  "term_definition",
  "Grm::DBIC::Ontology::Result::TermDefinition",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_synonyms

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::TermSynonym>

=cut

__PACKAGE__->has_many(
  "term_synonyms",
  "Grm::DBIC::Ontology::Result::TermSynonym",
  { "foreign.term_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_to_term_term1s

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::TermToTerm>

=cut

__PACKAGE__->has_many(
  "term_to_term_term1s",
  "Grm::DBIC::Ontology::Result::TermToTerm",
  { "foreign.term1_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_to_term_term2s

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::TermToTerm>

=cut

__PACKAGE__->has_many(
  "term_to_term_term2s",
  "Grm::DBIC::Ontology::Result::TermToTerm",
  { "foreign.term2_id" => "self.term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fkj9Ug3ltafBm8IajrqmAQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;