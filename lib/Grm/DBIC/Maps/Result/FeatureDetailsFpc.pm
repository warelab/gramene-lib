package Grm::DBIC::Maps::Result::FeatureDetailsFpc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsFpc

=cut

__PACKAGE__->table("feature_details_fpc");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 length_band

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 length_basepair

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 clone_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "length_band",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "length_basepair",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "clone_count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("feature_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 12:56:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E6MbECI9/UVTChGLwgdSwg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
