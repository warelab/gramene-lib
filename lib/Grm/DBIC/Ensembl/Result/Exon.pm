package Grm::DBIC::Ensembl::Result::Exon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Exon

=cut

__PACKAGE__->table("exon");

=head1 ACCESSORS

=head2 exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 phase

  data_type: 'tinyint'
  is_nullable: 0

=head2 end_phase

  data_type: 'tinyint'
  is_nullable: 0

=head2 is_current

  data_type: 'enum'
  default_value: 1
  extra: {list => [0,1]}
  is_nullable: 0

=head2 is_constitutive

  data_type: 'enum'
  default_value: 0
  extra: {list => [0,1]}
  is_nullable: 0

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 version

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 created_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 modified_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "exon_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "phase",
  { data_type => "tinyint", is_nullable => 0 },
  "end_phase",
  { data_type => "tinyint", is_nullable => 0 },
  "is_current",
  {
    data_type => "enum",
    default_value => 1,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
  "is_constitutive",
  {
    data_type => "enum",
    default_value => 0,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "version",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "created_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "modified_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("exon_id");

=head1 RELATIONS

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

=head2 exon_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ExonTranscript>

=cut

__PACKAGE__->has_many(
  "exon_transcripts",
  "Grm::DBIC::Ensembl::Result::ExonTranscript",
  { "foreign.exon_id" => "self.exon_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 splicing_event_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingEventFeature>

=cut

__PACKAGE__->has_many(
  "splicing_event_features",
  "Grm::DBIC::Ensembl::Result::SplicingEventFeature",
  { "foreign.exon_id" => "self.exon_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supporting_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SupportingFeature>

=cut

__PACKAGE__->has_many(
  "supporting_features",
  "Grm::DBIC::Ensembl::Result::SupportingFeature",
  { "foreign.exon_id" => "self.exon_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 translation_end_exons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Translation>

=cut

__PACKAGE__->has_many(
  "translation_end_exons",
  "Grm::DBIC::Ensembl::Result::Translation",
  { "foreign.end_exon_id" => "self.exon_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 translation_start_exons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Translation>

=cut

__PACKAGE__->has_many(
  "translation_start_exons",
  "Grm::DBIC::Ensembl::Result::Translation",
  { "foreign.start_exon_id" => "self.exon_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hdp7wZ+J4lTz0G86vchbyA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
