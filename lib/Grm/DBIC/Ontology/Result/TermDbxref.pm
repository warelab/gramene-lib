use utf8;
package Grm::DBIC::Ontology::Result::TermDbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::TermDbxref

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<term_dbxref>

=cut

__PACKAGE__->table("term_dbxref");

=head1 ACCESSORS

=head2 term_dbxref_id

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
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 is_for_definition

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_dbxref_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "dbxref_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "is_for_definition",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_dbxref_id>

=back

=cut

__PACKAGE__->set_primary_key("term_dbxref_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<term_id>

=over 4

=item * L</term_id>

=item * L</dbxref_id>

=item * L</is_for_definition>

=back

=cut

__PACKAGE__->add_unique_constraint("term_id", ["term_id", "dbxref_id", "is_for_definition"]);

=head1 RELATIONS

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::Ontology::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IByi4S7hntg362MUvCg4xQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
