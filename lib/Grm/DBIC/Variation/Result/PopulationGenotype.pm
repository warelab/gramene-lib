use utf8;
package Grm::DBIC::Variation::Result::PopulationGenotype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::PopulationGenotype

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<population_genotype>

=cut

__PACKAGE__->table("population_genotype");

=head1 ACCESSORS

=head2 population_genotype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 subsnp_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 genotype_code_id

  data_type: 'integer'
  is_nullable: 1

=head2 frequency

  data_type: 'float'
  is_nullable: 1

=head2 population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "population_genotype_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "subsnp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "genotype_code_id",
  { data_type => "integer", is_nullable => 1 },
  "frequency",
  { data_type => "float", is_nullable => 1 },
  "population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</population_genotype_id>

=back

=cut

__PACKAGE__->set_primary_key("population_genotype_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:20pKJTqd9mjbus77sIL6YA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
