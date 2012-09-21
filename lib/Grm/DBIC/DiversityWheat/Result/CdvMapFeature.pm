package Grm::DBIC::DiversityWheat::Result::CdvMapFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::CdvMapFeature

=cut

__PACKAGE__->table("cdv_map_feature");

=head1 ACCESSORS

=head2 cdv_map_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 chromosome_name

  data_type: 'text'
  is_nullable: 1

=head2 genetic_bin

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 xref_map_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 genetic_map

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 genetic_position

  data_type: 'double precision'
  is_nullable: 1

=head2 locus_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 physical_position

  data_type: 'double precision'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_map_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_map_feature_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "chromosome_name",
  { data_type => "text", is_nullable => 1 },
  "genetic_bin",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "xref_map_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genetic_map",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genetic_position",
  { data_type => "double precision", is_nullable => 1 },
  "locus_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "physical_position",
  { data_type => "double precision", is_nullable => 1 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_map_feature_id");

=head1 RELATIONS

=head2 cdv_map_feature_annotations

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::CdvMapFeatureAnnotation>

=cut

__PACKAGE__->has_many(
  "cdv_map_feature_annotations",
  "Grm::DBIC::DiversityWheat::Result::CdvMapFeatureAnnotation",
  { "foreign.cdv_map_feature_id" => "self.cdv_map_feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 cdv_markers

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::CdvMarker>

=cut

__PACKAGE__->has_many(
  "cdv_markers",
  "Grm::DBIC::DiversityWheat::Result::CdvMarker",
  { "foreign.cdv_map_feature_id" => "self.cdv_map_feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2pt8p019CBfwVlG8DL6KZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
