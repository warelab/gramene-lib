package Grm::DBIC::Diversity::Result::AztMarkerPosVersion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AztMarkerPosVersion

=cut

__PACKAGE__->table("azt_marker_pos_version");

=head1 ACCESSORS

=head2 cdv_marker_id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 version

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 cdv_marker_annotation_type_id

  data_type: 'integer'
  is_nullable: 1

=head2 annotation_value

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=cut

__PACKAGE__->add_columns(
  "cdv_marker_id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "version",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "cdv_marker_annotation_type_id",
  { data_type => "integer", is_nullable => 1 },
  "annotation_value",
  { data_type => "varchar", is_nullable => 1, size => 250 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lyD94TOGVGg92r1L3xin8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
