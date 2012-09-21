package Grm::DBIC::Maps::Result::OntologyTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::OntologyTerm

=cut

__PACKAGE__->table("ontology_term");

=head1 ACCESSORS

=head2 ontology_term_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ontology_term_type_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 term_accession

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "ontology_term_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ontology_term_type_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "term_accession",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);
__PACKAGE__->set_primary_key("ontology_term_id");
__PACKAGE__->add_unique_constraint(
  "ontology_term_type_id",
  ["ontology_term_type_id", "term_accession"],
);

=head1 RELATIONS

=head2 feature_to_ontology_terms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::FeatureToOntologyTerm>

=cut

__PACKAGE__->has_many(
  "feature_to_ontology_terms",
  "Grm::DBIC::Maps::Result::FeatureToOntologyTerm",
  { "foreign.ontology_term_id" => "self.ontology_term_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ontology_term_type

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::OntologyTermType>

=cut

__PACKAGE__->belongs_to(
  "ontology_term_type",
  "Grm::DBIC::Maps::Result::OntologyTermType",
  { ontology_term_type_id => "ontology_term_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O3M+75R9+lEFSCimyO25kQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
