package Grm::DBIC::Diversity::Result::AuxMarkerAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxMarkerAnnotation

=cut

__PACKAGE__->table("aux_marker_annotations");

=head1 ACCESSORS

=head2 aux_marker_annotations_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_marker_id

  data_type: 'integer'
  is_nullable: 1

=head2 marker_type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 allele_repeat

  data_type: 'text'
  is_nullable: 1

=head2 allele_repeat_size

  data_type: 'text'
  is_nullable: 1

=head2 chr

  data_type: 'integer'
  is_nullable: 1

=head2 chr_start

  data_type: 'integer'
  is_nullable: 1

=head2 multiple_positions

  data_type: 'text'
  is_nullable: 1

=head2 approximate_position

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_marker_annotations_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cdv_marker_id",
  { data_type => "integer", is_nullable => 1 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "allele_repeat",
  { data_type => "text", is_nullable => 1 },
  "allele_repeat_size",
  { data_type => "text", is_nullable => 1 },
  "chr",
  { data_type => "integer", is_nullable => 1 },
  "chr_start",
  { data_type => "integer", is_nullable => 1 },
  "multiple_positions",
  { data_type => "text", is_nullable => 1 },
  "approximate_position",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_marker_annotations_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fRZX10vBfqBHAugW2RFHFQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
