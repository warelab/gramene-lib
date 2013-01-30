package Grm::DBIC::OntologyTax::Result::RelationshipType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyTax::Result::RelationshipType

=cut

__PACKAGE__->table("relationship_type");

=head1 ACCESSORS

=head2 relationship_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 type_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "relationship_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "type_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("relationship_type_id");

=head1 RELATIONS

=head2 term_to_terms

Type: has_many

Related object: L<Grm::DBIC::OntologyTax::Result::TermToTerm>

=cut

__PACKAGE__->has_many(
  "term_to_terms",
  "Grm::DBIC::OntologyTax::Result::TermToTerm",
  { "foreign.relationship_type_id" => "self.relationship_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PIx5mG8jvzK6mqpibkcKow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
