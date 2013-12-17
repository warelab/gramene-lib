use utf8;
package Grm::DBIC::Ontology::Result::TermDefinition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::TermDefinition

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<term_definition>

=cut

__PACKAGE__->table("term_definition");

=head1 ACCESSORS

=head2 term_definition_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 definition

  data_type: 'text'
  is_nullable: 0

=head2 term_comment

  data_type: 'text'
  is_nullable: 1

=head2 reference

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "term_definition_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "dbxref_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "definition",
  { data_type => "text", is_nullable => 0 },
  "term_comment",
  { data_type => "text", is_nullable => 1 },
  "reference",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_definition_id>

=back

=cut

__PACKAGE__->set_primary_key("term_definition_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<term_id>

=over 4

=item * L</term_id>

=back

=cut

__PACKAGE__->add_unique_constraint("term_id", ["term_id"]);

=head1 RELATIONS

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::Ontology::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::Ontology::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CiqjdAk2BF8M4kJP0EHMYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
