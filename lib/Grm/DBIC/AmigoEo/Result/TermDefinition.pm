package Grm::DBIC::AmigoEo::Result::TermDefinition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoEo::Result::TermDefinition

=cut

__PACKAGE__->table("term_definition");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 term_definition

  data_type: 'text'
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  is_nullable: 1

=head2 term_comment

  data_type: 'mediumtext'
  is_nullable: 1

=head2 reference

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "term_definition",
  { data_type => "text", is_nullable => 0 },
  "dbxref_id",
  { data_type => "integer", is_nullable => 1 },
  "term_comment",
  { data_type => "mediumtext", is_nullable => 1 },
  "reference",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->add_unique_constraint("term_id", ["term_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HYYuf2LNDEep2dFlyC8MhA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
