package Grm::DBIC::DiversityWheat::Result::CdvMarker;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::CdvMarker

=cut

__PACKAGE__->table("cdv_marker");

=head1 ACCESSORS

=head2 cdv_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_marker_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_map_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_ref_stock_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 position

  data_type: 'integer'
  is_nullable: 1

=head2 length

  data_type: 'integer'
  is_nullable: 1

=head2 ref_seq

  data_type: 'text'
  is_nullable: 1

=head2 marker_aid

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_marker_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_map_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_ref_stock_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "position",
  { data_type => "integer", is_nullable => 1 },
  "length",
  { data_type => "integer", is_nullable => 1 },
  "ref_seq",
  { data_type => "text", is_nullable => 1 },
  "marker_aid",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_marker_id");

=head1 RELATIONS

=head2 cdv_map_feature

Type: belongs_to

Related object: L<Grm::DBIC::DiversityWheat::Result::CdvMapFeature>

=cut

__PACKAGE__->belongs_to(
  "cdv_map_feature",
  "Grm::DBIC::DiversityWheat::Result::CdvMapFeature",
  { cdv_map_feature_id => "cdv_map_feature_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_ref_stock

Type: belongs_to

Related object: L<Grm::DBIC::DiversityWheat::Result::DivStock>

=cut

__PACKAGE__->belongs_to(
  "div_ref_stock",
  "Grm::DBIC::DiversityWheat::Result::DivStock",
  { div_stock_id => "div_ref_stock_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cdv_marker_annotations

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::CdvMarkerAnnotation>

=cut

__PACKAGE__->has_many(
  "cdv_marker_annotations",
  "Grm::DBIC::DiversityWheat::Result::CdvMarkerAnnotation",
  { "foreign.cdv_marker_id" => "self.cdv_marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_allele_assays

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::DivAlleleAssay>

=cut

__PACKAGE__->has_many(
  "div_allele_assays",
  "Grm::DBIC::DiversityWheat::Result::DivAlleleAssay",
  { "foreign.cdv_marker_id" => "self.cdv_marker_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XoGW+aONCxRnGFcuXRWwNw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
