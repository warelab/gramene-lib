package Grm::DBIC::OntologyEo::Result::TermDbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyEo::Result::TermDbxref

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
__PACKAGE__->set_primary_key("term_dbxref_id");
__PACKAGE__->add_unique_constraint("term_id", ["term_id", "dbxref_id", "is_for_definition"]);

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::OntologyEo::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::OntologyEo::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::OntologyEo::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::OntologyEo::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lMdx8i22raNvU6vBSqNUHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
