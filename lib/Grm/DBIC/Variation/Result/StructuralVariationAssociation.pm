use utf8;
package Grm::DBIC::Variation::Result::StructuralVariationAssociation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::StructuralVariationAssociation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<structural_variation_association>

=cut

__PACKAGE__->table("structural_variation_association");

=head1 ACCESSORS

=head2 structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 supporting_structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "structural_variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "supporting_structural_variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</structural_variation_id>

=item * L</supporting_structural_variation_id>

=back

=cut

__PACKAGE__->set_primary_key(
  "structural_variation_id",
  "supporting_structural_variation_id",
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:04GaewJJA4VK9IyooOJg3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
