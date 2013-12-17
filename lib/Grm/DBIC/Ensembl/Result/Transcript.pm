use utf8;
package Grm::DBIC::Ensembl::Result::Transcript;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Transcript

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<transcript>

=cut

__PACKAGE__->table("transcript");

=head1 ACCESSORS

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
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

=head2 display_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 biotype

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 status

  data_type: 'enum'
  extra: {list => ["KNOWN","NOVEL","PUTATIVE","PREDICTED","KNOWN_BY_PROJECTION","UNKNOWN","ANNOTATED"]}
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 is_current

  data_type: 'enum'
  default_value: 1
  extra: {list => [0,1]}
  is_nullable: 0

=head2 canonical_translation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 version

  data_type: 'smallint'
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
  "transcript_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "analysis_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
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
  "display_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "biotype",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "status",
  {
    data_type => "enum",
    extra => {
      list => [
        "KNOWN",
        "NOVEL",
        "PUTATIVE",
        "PREDICTED",
        "KNOWN_BY_PROJECTION",
        "UNKNOWN",
        "ANNOTATED",
      ],
    },
    is_nullable => 1,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "is_current",
  {
    data_type => "enum",
    default_value => 1,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
  "canonical_translation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "version",
  {
    data_type => "smallint",
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

=head1 PRIMARY KEY

=over 4

=item * L</transcript_id>

=back

=cut

__PACKAGE__->set_primary_key("transcript_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<canonical_translation_idx>

=over 4

=item * L</canonical_translation_id>

=back

=cut

__PACKAGE__->add_unique_constraint("canonical_translation_idx", ["canonical_translation_id"]);

=head1 RELATIONS

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 canonical_translation

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Translation>

=cut

__PACKAGE__->belongs_to(
  "canonical_translation",
  "Grm::DBIC::Ensembl::Result::Translation",
  { translation_id => "canonical_translation_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 display_xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Xref>

=cut

__PACKAGE__->belongs_to(
  "display_xref",
  "Grm::DBIC::Ensembl::Result::Xref",
  { xref_id => "display_xref_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 exon_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ExonTranscript>

=cut

__PACKAGE__->has_many(
  "exon_transcripts",
  "Grm::DBIC::Ensembl::Result::ExonTranscript",
  { "foreign.transcript_id" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Ensembl::Result::Gene",
  { gene_id => "gene_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 genes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->has_many(
  "genes",
  "Grm::DBIC::Ensembl::Result::Gene",
  { "foreign.canonical_transcript_id" => "self.transcript_id" },
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

=head2 splicing_event_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingEventFeature>

=cut

__PACKAGE__->has_many(
  "splicing_event_features",
  "Grm::DBIC::Ensembl::Result::SplicingEventFeature",
  { "foreign.transcript_id" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 splicing_transcript_pair_transcript_id_1s

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingTranscriptPair>

=cut

__PACKAGE__->has_many(
  "splicing_transcript_pair_transcript_id_1s",
  "Grm::DBIC::Ensembl::Result::SplicingTranscriptPair",
  { "foreign.transcript_id_1" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 splicing_transcript_pair_transcript_id_2s

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingTranscriptPair>

=cut

__PACKAGE__->has_many(
  "splicing_transcript_pair_transcript_id_2s",
  "Grm::DBIC::Ensembl::Result::SplicingTranscriptPair",
  { "foreign.transcript_id_2" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcript_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::TranscriptAttrib>

=cut

__PACKAGE__->has_many(
  "transcript_attribs",
  "Grm::DBIC::Ensembl::Result::TranscriptAttrib",
  { "foreign.transcript_id" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcript_supporting_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::TranscriptSupportingFeature>

=cut

__PACKAGE__->has_many(
  "transcript_supporting_features",
  "Grm::DBIC::Ensembl::Result::TranscriptSupportingFeature",
  { "foreign.transcript_id" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 translations

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Translation>

=cut

__PACKAGE__->has_many(
  "translations",
  "Grm::DBIC::Ensembl::Result::Translation",
  { "foreign.transcript_id" => "self.transcript_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kzLKmo/pzMy+LPp8ZOE3CA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
