package Grm::DBIC::OntologyGaz::Result::TermSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyGaz::Result::TermSynonym

=cut

__PACKAGE__->table("term_synonym");

=head1 ACCESSORS

=head2 term_synonym_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term_synonym

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=cut

__PACKAGE__->add_columns(
  "term_synonym_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term_synonym",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 500 },
);
__PACKAGE__->set_primary_key("term_synonym_id");
__PACKAGE__->add_unique_constraint("term_id", ["term_id", "term_synonym"]);

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::OntologyGaz::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::OntologyGaz::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M3XiWdk2VYfOiVkTm3bPaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
