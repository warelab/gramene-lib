use utf8;
package Grm::DBIC::Variation::Result::TaggedVariationFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::TaggedVariationFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<tagged_variation_feature>

=cut

__PACKAGE__->table("tagged_variation_feature");

=head1 ACCESSORS

=head2 variation_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 tagged_variation_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "variation_feature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "tagged_variation_feature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "population_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZPR204b+W/0fOU9oS9UhDg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
