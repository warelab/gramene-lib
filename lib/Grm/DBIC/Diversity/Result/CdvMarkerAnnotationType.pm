package Grm::DBIC::Diversity::Result::CdvMarkerAnnotationType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvMarkerAnnotationType

=cut

__PACKAGE__->table("cdv_marker_annotation_type");

=head1 ACCESSORS

=head2 cdv_marker_annotation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_marker_annotation_type_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 anno_type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_marker_annotation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_marker_annotation_type_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "anno_type",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_marker_annotation_type_id");

=head1 RELATIONS

=head2 cdv_marker_annotations

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::CdvMarkerAnnotation>

=cut

__PACKAGE__->has_many(
  "cdv_marker_annotations",
  "Grm::DBIC::Diversity::Result::CdvMarkerAnnotation",
  {
    "foreign.cdv_marker_annotation_type_id" => "self.cdv_marker_annotation_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zKtv/C78EJW0e1W1IIKgpw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
