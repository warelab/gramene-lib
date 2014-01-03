use utf8;
package Grm::DBIC::Variation::Result::FailedVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::FailedVariation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<failed_variation>

=cut

__PACKAGE__->table("failed_variation");

=head1 ACCESSORS

=head2 failed_variation_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 failed_description_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "failed_variation_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "failed_description_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</failed_variation_id>

=back

=cut

__PACKAGE__->set_primary_key("failed_variation_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<variation_idx>

=over 4

=item * L</variation_id>

=item * L</failed_description_id>

=back

=cut

__PACKAGE__->add_unique_constraint("variation_idx", ["variation_id", "failed_description_id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8qhbG+s5ucngbSJjDyAyvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
