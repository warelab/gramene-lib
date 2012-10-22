package Grm::DBIC::Compara::Result::ConstrainedElement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::ConstrainedElement

=cut

__PACKAGE__->table("constrained_element");

=head1 ACCESSORS

=head2 constrained_element_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_strand

  data_type: 'integer'
  is_nullable: 1

=head2 method_link_species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 p_value

  data_type: 'double precision'
  is_nullable: 1

=head2 score

  data_type: 'double precision'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "constrained_element_id",
  { data_type => "bigint", extra => { unsigned => 1 }, is_nullable => 0 },
  "dnafrag_id",
  { data_type => "bigint", extra => { unsigned => 1 }, is_nullable => 0 },
  "dnafrag_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "dnafrag_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "dnafrag_strand",
  { data_type => "integer", is_nullable => 1 },
  "method_link_species_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "p_value",
  { data_type => "double precision", is_nullable => 1 },
  "score",
  { data_type => "double precision", default_value => 0, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3FWW2j7zGh0iIocaVyXH8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
