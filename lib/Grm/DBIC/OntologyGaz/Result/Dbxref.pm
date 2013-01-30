package Grm::DBIC::OntologyGaz::Result::Dbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyGaz::Result::Dbxref

=cut

__PACKAGE__->table("dbxref");

=head1 ACCESSORS

=head2 dbxref_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 xref_key

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 xref_keytype

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 xref_dbname

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 xref_desc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "dbxref_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "xref_key",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "xref_keytype",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "xref_dbname",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "xref_desc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("dbxref_id");
__PACKAGE__->add_unique_constraint("xref_key", ["xref_key", "xref_keytype", "xref_dbname"]);

=head1 RELATIONS

=head2 evidences

Type: has_many

Related object: L<Grm::DBIC::OntologyGaz::Result::Evidence>

=cut

__PACKAGE__->has_many(
  "evidences",
  "Grm::DBIC::OntologyGaz::Result::Evidence",
  { "foreign.dbxref_id" => "self.dbxref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_dbxrefs

Type: has_many

Related object: L<Grm::DBIC::OntologyGaz::Result::TermDbxref>

=cut

__PACKAGE__->has_many(
  "term_dbxrefs",
  "Grm::DBIC::OntologyGaz::Result::TermDbxref",
  { "foreign.dbxref_id" => "self.dbxref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 term_definitions

Type: has_many

Related object: L<Grm::DBIC::OntologyGaz::Result::TermDefinition>

=cut

__PACKAGE__->has_many(
  "term_definitions",
  "Grm::DBIC::OntologyGaz::Result::TermDefinition",
  { "foreign.dbxref_id" => "self.dbxref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a0EuuHOLP+GMw8NZ8hHrwg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;