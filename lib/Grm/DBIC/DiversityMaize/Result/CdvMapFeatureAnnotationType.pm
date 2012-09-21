package Grm::DBIC::DiversityMaize::Result::CdvMapFeatureAnnotationType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::CdvMapFeatureAnnotationType

=cut

__PACKAGE__->table("cdv_map_feature_annotation_type");

=head1 ACCESSORS

=head2 cdv_map_feature_annotation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_annotation_type_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 anno_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_map_feature_annotation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_map_feature_annotation_type_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "anno_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_map_feature_annotation_type_id");
__PACKAGE__->add_unique_constraint(
  "cdv_map_feature_annotation_type_acc",
  ["cdv_map_feature_annotation_type_acc"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:76OoqZ5hdyVuffd8MXwAhg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
