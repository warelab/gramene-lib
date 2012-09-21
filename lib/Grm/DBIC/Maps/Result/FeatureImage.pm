package Grm::DBIC::Maps::Result::FeatureImage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureImage

=cut

__PACKAGE__->table("feature_image");

=head1 ACCESSORS

=head2 feature_image_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 file_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 caption

  data_type: 'text'
  is_nullable: 1

=head2 width

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 height

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_image_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "file_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "caption",
  { data_type => "text", is_nullable => 1 },
  "width",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "height",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("feature_image_id");
__PACKAGE__->add_unique_constraint("feature_id", ["feature_id", "file_name"]);

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9lDAacymJRlIk53Lbwpalg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
