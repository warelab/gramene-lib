use utf8;
package Grm::DBIC::Variation::Result::CompressedGenotypeVar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::CompressedGenotypeVar

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<compressed_genotype_var>

=cut

__PACKAGE__->table("compressed_genotype_var");

=head1 ACCESSORS

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 subsnp_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 genotypes

  data_type: 'blob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "subsnp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "genotypes",
  { data_type => "blob", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Js+HmKqrBv8Vn2J+fdnC3A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
