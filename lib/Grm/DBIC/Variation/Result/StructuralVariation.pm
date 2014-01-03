use utf8;
package Grm::DBIC::Variation::Result::StructuralVariation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::StructuralVariation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<structural_variation>

=cut

__PACKAGE__->table("structural_variation");

=head1 ACCESSORS

=head2 structural_variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 variation_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 alias

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

=head2 clinical_significance_attrib_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 validation_status

  data_type: 'enum'
  extra: {list => ["validated","not validated","high quality"]}
  is_nullable: 1

=head2 is_evidence

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 somatic

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "structural_variation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "variation_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "alias",
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
  "clinical_significance_attrib_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "validation_status",
  {
    data_type => "enum",
    extra => { list => ["validated", "not validated", "high quality"] },
    is_nullable => 1,
  },
  "is_evidence",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "somatic",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</structural_variation_id>

=back

=cut

__PACKAGE__->set_primary_key("structural_variation_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BOrs4MpnQqvWLNkl9/8MIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
