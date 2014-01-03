use utf8;
package Grm::DBIC::Variation::Result::Allele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Allele

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<allele>

=cut

__PACKAGE__->table("allele");

=head1 ACCESSORS

=head2 allele_id

  data_type: 'integer'
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

=head2 allele_code_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 frequency

  data_type: 'float'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 frequency_submitter_handle

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "allele_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "subsnp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "allele_code_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "frequency",
  { data_type => "float", extra => { unsigned => 1 }, is_nullable => 1 },
  "count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "frequency_submitter_handle",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</allele_id>

=back

=cut

__PACKAGE__->set_primary_key("allele_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dHJ/4JVWfBn5UjoLEv+Seg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
