package Grm::DBIC::Ensembl::Result::DitagFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::DitagFeature

=cut

__PACKAGE__->table("ditag_feature");

=head1 ACCESSORS

=head2 ditag_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ditag_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 ditag_pair_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
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

=head2 analysis_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 hit_start

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hit_end

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hit_strand

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 cigar_line

  data_type: 'tinytext'
  is_nullable: 0

=head2 ditag_side

  data_type: 'enum'
  extra: {list => ["F","L","R"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ditag_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ditag_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "ditag_pair_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
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
  "analysis_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "hit_start",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "hit_end",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "hit_strand",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "cigar_line",
  { data_type => "tinytext", is_nullable => 0 },
  "ditag_side",
  {
    data_type => "enum",
    extra => { list => ["F", "L", "R"] },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("ditag_feature_id");

=head1 RELATIONS

=head2 ditag

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Ditag>

=cut

__PACKAGE__->belongs_to(
  "ditag",
  "Grm::DBIC::Ensembl::Result::Ditag",
  { ditag_id => "ditag_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OTc0sEc0ScyvcbLQtAR17w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
