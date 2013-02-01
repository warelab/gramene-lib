package Grm::DBIC::AmigoEo::Result::TermSubset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoEo::Result::TermSubset

=cut

__PACKAGE__->table("term_subset");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 subset_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "subset_id",
  { data_type => "integer", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PKB/bAu+vfoEr1uFU7sVHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
