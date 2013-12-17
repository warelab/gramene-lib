use utf8;
package Grm::DBIC::Ensembl::Result::MiscFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MiscFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<misc_feature>

=cut

__PACKAGE__->table("misc_feature");

=head1 ACCESSORS

=head2 misc_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "misc_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_start",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "seq_region_end",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "seq_region_strand",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</misc_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("misc_feature_id");

=head1 RELATIONS

=head2 misc_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MiscAttrib>

=cut

__PACKAGE__->has_many(
  "misc_attribs",
  "Grm::DBIC::Ensembl::Result::MiscAttrib",
  { "foreign.misc_feature_id" => "self.misc_feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 misc_feature_misc_sets

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet>

=cut

__PACKAGE__->has_many(
  "misc_feature_misc_sets",
  "Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet",
  { "foreign.misc_feature_id" => "self.misc_feature_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 misc_sets

Type: many_to_many

Composing rels: L</misc_feature_misc_sets> -> misc_set

=cut

__PACKAGE__->many_to_many("misc_sets", "misc_feature_misc_sets", "misc_set");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 16:58:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qw7HEUVHwXMBbu6stBGVxQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
