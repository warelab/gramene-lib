use utf8;
package Grm::DBIC::Variation::Result::IndividualGenotypeMultipleBp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::IndividualGenotypeMultipleBp

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<individual_genotype_multiple_bp>

=cut

__PACKAGE__->table("individual_genotype_multiple_bp");

=head1 ACCESSORS

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 subsnp_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 allele_1

  data_type: 'varchar'
  is_nullable: 1
  size: 25000

=head2 allele_2

  data_type: 'varchar'
  is_nullable: 1
  size: 25000

=head2 individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "subsnp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "allele_1",
  { data_type => "varchar", is_nullable => 1, size => 25000 },
  "allele_2",
  { data_type => "varchar", is_nullable => 1, size => 25000 },
  "individual_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CCvWr4fGNI5TknkyDZXfig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
