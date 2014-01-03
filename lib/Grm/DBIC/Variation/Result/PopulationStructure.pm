use utf8;
package Grm::DBIC::Variation::Result::PopulationStructure;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::PopulationStructure

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<population_structure>

=cut

__PACKAGE__->table("population_structure");

=head1 ACCESSORS

=head2 super_population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sub_population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "super_population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "sub_population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<super_population_idx>

=over 4

=item * L</super_population_id>

=item * L</sub_population_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "super_population_idx",
  ["super_population_id", "sub_population_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sumEF+Zg111XT1LNYQJceQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
