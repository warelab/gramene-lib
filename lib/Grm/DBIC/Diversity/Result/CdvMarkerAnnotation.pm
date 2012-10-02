package Grm::DBIC::Diversity::Result::CdvMarkerAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvMarkerAnnotation

=cut

__PACKAGE__->table("cdv_marker_annotation");

=head1 ACCESSORS

=head2 cdv_marker_annotation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_marker_annotation_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 cdv_marker_annotation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 annotation_value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cdv_marker_annotation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_marker_annotation_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "cdv_marker_annotation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "annotation_value",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("cdv_marker_annotation_id");

=head1 RELATIONS

=head2 cdv_marker

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::CdvMarker>

=cut

__PACKAGE__->belongs_to(
  "cdv_marker",
  "Grm::DBIC::Diversity::Result::CdvMarker",
  { cdv_marker_id => "cdv_marker_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 cdv_marker_annotation_type

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::CdvMarkerAnnotationType>

=cut

__PACKAGE__->belongs_to(
  "cdv_marker_annotation_type",
  "Grm::DBIC::Diversity::Result::CdvMarkerAnnotationType",
  {
    cdv_marker_annotation_type_id => "cdv_marker_annotation_type_id",
  },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kuunguPBtp/8nonZA6mR3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
