use utf8;
package Grm::DBIC::Variation::Result::StructuralVariationFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::StructuralVariationFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<structural_variation_feature>

=cut

__PACKAGE__->table("structural_variation_feature");

=head1 ACCESSORS

=head2 structural_variation_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 outer_start

  data_type: 'integer'
  is_nullable: 1

=head2 seq_region_start

  data_type: 'integer'
  is_nullable: 0

=head2 inner_start

  data_type: 'integer'
  is_nullable: 1

=head2 inner_end

  data_type: 'integer'
  is_nullable: 1

=head2 seq_region_end

  data_type: 'integer'
  is_nullable: 0

=head2 outer_end

  data_type: 'integer'
  is_nullable: 1

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 variation_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 study_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 class_attrib_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 allele_string

  data_type: 'longtext'
  is_nullable: 1

=head2 is_evidence

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 variation_set_id

  data_type: 'set'
  default_value: (empty string)
  extra: {list => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64]}
  is_nullable: 0

=head2 somatic

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 breakpoint_order

  data_type: 'tinyint'
  is_nullable: 1

=head2 length

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "structural_variation_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "outer_start",
  { data_type => "integer", is_nullable => 1 },
  "seq_region_start",
  { data_type => "integer", is_nullable => 0 },
  "inner_start",
  { data_type => "integer", is_nullable => 1 },
  "inner_end",
  { data_type => "integer", is_nullable => 1 },
  "seq_region_end",
  { data_type => "integer", is_nullable => 0 },
  "outer_end",
  { data_type => "integer", is_nullable => 1 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "structural_variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "variation_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "study_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "class_attrib_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "allele_string",
  { data_type => "longtext", is_nullable => 1 },
  "is_evidence",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "variation_set_id",
  {
    data_type => "set",
    default_value => "",
    extra => { list => [1 .. 64] },
    is_nullable => 0,
  },
  "somatic",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "breakpoint_order",
  { data_type => "tinyint", is_nullable => 1 },
  "length",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</structural_variation_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("structural_variation_feature_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N4aJLMn5ja5XxmdEu+G/0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
