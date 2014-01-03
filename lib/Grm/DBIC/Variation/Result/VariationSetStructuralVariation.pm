use utf8;
package Grm::DBIC::Variation::Result::VariationSetStructuralVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::VariationSetStructuralVariation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<variation_set_structural_variation>

=cut

__PACKAGE__->table("variation_set_structural_variation");

=head1 ACCESSORS

=head2 structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 variation_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "structural_variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "variation_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</structural_variation_id>

=item * L</variation_set_id>

=back

=cut

__PACKAGE__->set_primary_key("structural_variation_id", "variation_set_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ka0RtzbTUv2bXfCVKba7BA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
