package Grm::DBIC::Amigo::Result::TermDbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::TermDbxref

=cut

__PACKAGE__->table("term_dbxref");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  is_nullable: 0

=head2 is_for_definition

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "dbxref_id",
  { data_type => "integer", is_nullable => 0 },
  "is_for_definition",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->add_unique_constraint("term_id", ["term_id", "dbxref_id", "is_for_definition"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SWg6feVd5hN3l4id+v2Z0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
