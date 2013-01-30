package Grm::DBIC::OntologyGaz::Result::TermToTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyGaz::Result::TermToTerm

=cut

__PACKAGE__->table("term_to_term");

=head1 ACCESSORS

=head2 term_to_term_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term1_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term2_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_to_term_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "relationship_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term1_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term2_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);
__PACKAGE__->set_primary_key("term_to_term_id");
__PACKAGE__->add_unique_constraint("term1_id", ["term1_id", "term2_id", "relationship_type_id"]);

=head1 RELATIONS

=head2 relationship_type

Type: belongs_to

Related object: L<Grm::DBIC::OntologyGaz::Result::RelationshipType>

=cut

__PACKAGE__->belongs_to(
  "relationship_type",
  "Grm::DBIC::OntologyGaz::Result::RelationshipType",
  { relationship_type_id => "relationship_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 term1

Type: belongs_to

Related object: L<Grm::DBIC::OntologyGaz::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term1",
  "Grm::DBIC::OntologyGaz::Result::Term",
  { term_id => "term1_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 term2

Type: belongs_to

Related object: L<Grm::DBIC::OntologyGaz::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term2",
  "Grm::DBIC::OntologyGaz::Result::Term",
  { term_id => "term2_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1pCxpdCnhkPisEnVXuwesg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
