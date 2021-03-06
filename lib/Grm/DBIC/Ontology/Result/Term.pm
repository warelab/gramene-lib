use utf8;
package Grm::DBIC::Ontology::Result::Term;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::Term

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<term>

=cut

__PACKAGE__->table("term");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

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
  "name",
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

=head1 PRIMARY KEY

=over 4

=item * L</term_id>

=back

=cut

__PACKAGE__->set_primary_key("term_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<term_type_id>

=over 4

=item * L</term_type_id>

=item * L</term_accession>

=back

=cut

__PACKAGE__->add_unique_constraint("term_type_id", ["term_type_id", "term_accession"]);

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

=head2 term_type

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::TermType>

=cut

__PACKAGE__->belongs_to(
  "term_type",
  "Grm::DBIC::Ontology::Result::TermType",
  { term_type_id => "term_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xf1q3ZsT+t/7peJvgMrYiw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
