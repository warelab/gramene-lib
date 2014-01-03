use utf8;
package Grm::DBIC::Variation::Result::IndividualPopulation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::IndividualPopulation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<individual_population>

=cut

__PACKAGE__->table("individual_population");

=head1 ACCESSORS

=head2 individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "individual_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1xn3poQpZZfAKdhK1Ppoew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
