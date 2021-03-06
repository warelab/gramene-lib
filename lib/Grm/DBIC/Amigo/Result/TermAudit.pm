package Grm::DBIC::Amigo::Result::TermAudit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::TermAudit

=cut

__PACKAGE__->table("term_audit");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 term_loadtime

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "term_loadtime",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("term_id", ["term_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/E7Cbqa6UwlyWs2J/DoqMA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
