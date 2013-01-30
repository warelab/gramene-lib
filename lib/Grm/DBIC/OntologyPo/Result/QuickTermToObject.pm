package Grm::DBIC::OntologyPo::Result::QuickTermToObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyPo::Result::QuickTermToObject

=cut

__PACKAGE__->table("quick_term_to_object");

=head1 ACCESSORS

=head2 quick_term_to_object_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 15

=head2 term_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 term_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 object_database

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 object_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 object_accession_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 object_symbol

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 object_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 object_synonyms

  data_type: 'text'
  is_nullable: 1

=head2 object_species

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 evidences

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "quick_term_to_object_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 15 },
  "term_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "term_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "object_database",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "object_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "object_accession_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "object_symbol",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "object_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "object_synonyms",
  { data_type => "text", is_nullable => 1 },
  "object_species",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "evidences",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("quick_term_to_object_id");
__PACKAGE__->add_unique_constraint(
  "term_id",
  [
    "term_id",
    "object_database",
    "object_type",
    "object_accession_id",
  ],
);

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::OntologyPo::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::OntologyPo::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aSThJPWE+ha1cNFQwRyDUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
