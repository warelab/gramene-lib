package Grm::DBIC::DiversityMaize::Result::CdvMapFeatureAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::CdvMapFeatureAnnotation

=cut

__PACKAGE__->table("cdv_map_feature_annotation");

=head1 ACCESSORS

=head2 cdv_map_feature_annotation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_annotation_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_map_feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cdv_map_feature_annotation_type_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 annotation_value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cdv_map_feature_annotation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_map_feature_annotation_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_map_feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "cdv_map_feature_annotation_type_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "annotation_value",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("cdv_map_feature_annotation_id");
__PACKAGE__->add_unique_constraint(
  "cdv_map_feature_annotation_acc",
  ["cdv_map_feature_annotation_acc"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CfiviivYeh4h01pJF8Ya1w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
