use utf8;
package Grm::DBIC::Variation::Result::FailedStructuralVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::FailedStructuralVariation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<failed_structural_variation>

=cut

__PACKAGE__->table("failed_structural_variation");

=head1 ACCESSORS

=head2 failed_structural_variation_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 failed_description_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "failed_structural_variation_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "structural_variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "failed_description_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</failed_structural_variation_id>

=back

=cut

__PACKAGE__->set_primary_key("failed_structural_variation_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<structural_variation_idx>

=over 4

=item * L</structural_variation_id>

=item * L</failed_description_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "structural_variation_idx",
  ["structural_variation_id", "failed_description_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NngENhGw0iGTp8aSmVXWRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
