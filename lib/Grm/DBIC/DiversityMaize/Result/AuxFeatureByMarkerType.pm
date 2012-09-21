package Grm::DBIC::DiversityMaize::Result::AuxFeatureByMarkerType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxFeatureByMarkerType

=cut

__PACKAGE__->table("aux_feature_by_marker_type");

=head1 ACCESSORS

=head2 aux_feature_by_marker_type

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_id

  data_type: 'integer'
  is_nullable: 1

=head2 marker_type_string

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "aux_feature_by_marker_type",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cdv_map_feature_id",
  { data_type => "integer", is_nullable => 1 },
  "marker_type_string",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("aux_feature_by_marker_type");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ruwtRUcsqosGXraeD/Zreg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
