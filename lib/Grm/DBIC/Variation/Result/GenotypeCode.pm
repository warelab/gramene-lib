use utf8;
package Grm::DBIC::Variation::Result::GenotypeCode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::GenotypeCode

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<genotype_code>

=cut

__PACKAGE__->table("genotype_code");

=head1 ACCESSORS

=head2 genotype_code_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 allele_code_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 haplotype_id

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 phased

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "genotype_code_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "allele_code_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "haplotype_id",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 0 },
  "phased",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lsgC54rtSmK8udYT4e9rTw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
