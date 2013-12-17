use utf8;
package Grm::DBIC::Ontology::Result::RelationshipType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::RelationshipType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<relationship_type>

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

=head1 PRIMARY KEY

=over 4

=item * L</relationship_type_id>

=back

=cut

__PACKAGE__->set_primary_key("relationship_type_id");

=head1 RELATIONS

=head2 term_to_terms

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::TermToTerm>

=cut

__PACKAGE__->has_many(
  "term_to_terms",
  "Grm::DBIC::Ontology::Result::TermToTerm",
  { "foreign.relationship_type_id" => "self.relationship_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mjvaz2UZ7pBvpBnxHLc7Mw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
