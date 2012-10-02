package Grm::DBIC::Diversity::Result::AuxFeatureByMarkerType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxFeatureByMarkerType

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ks8wb4A3fqj8XrAc8InUjA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
