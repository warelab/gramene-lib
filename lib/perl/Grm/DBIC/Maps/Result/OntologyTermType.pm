package Grm::DBIC::Maps::Result::OntologyTermType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::OntologyTermType

=cut

__PACKAGE__->table("ontology_term_type");

=head1 ACCESSORS

=head2 ontology_term_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 term_type

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "ontology_term_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "term_type",
  { data_type => "varchar", is_nullable => 1, size => 128 },
);
__PACKAGE__->set_primary_key("ontology_term_type_id");
__PACKAGE__->add_unique_constraint("term_type", ["term_type"]);

=head1 RELATIONS

=head2 ontology_terms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::OntologyTerm>

=cut

__PACKAGE__->has_many(
  "ontology_terms",
  "Grm::DBIC::Maps::Result::OntologyTerm",
  { "foreign.ontology_term_type_id" => "self.ontology_term_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1yxb9O7T5+J+rm0iJIYPTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
