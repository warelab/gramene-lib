use utf8;
package Grm::DBIC::Variation::Result::FailedAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::FailedAllele

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<failed_allele>

=cut

__PACKAGE__->table("failed_allele");

=head1 ACCESSORS

=head2 failed_allele_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 failed_description_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "failed_allele_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "allele_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "failed_description_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</failed_allele_id>

=back

=cut

__PACKAGE__->set_primary_key("failed_allele_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<allele_idx>

=over 4

=item * L</allele_id>

=item * L</failed_description_id>

=back

=cut

__PACKAGE__->add_unique_constraint("allele_idx", ["allele_id", "failed_description_id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+hiRQcryqkxDfc46vFIz/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
