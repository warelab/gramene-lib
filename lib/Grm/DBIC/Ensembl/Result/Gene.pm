package Grm::DBIC::Ensembl::Result::Gene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Gene

=cut

__PACKAGE__->table("gene");

=head1 ACCESSORS

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 biotype

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 analysis_id

  data_type: 'integer'
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

=head2 source

  data_type: 'varchar'
  is_nullable: 0
  size: 20

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

=head2 canonical_transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 canonical_annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 255

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
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "biotype",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "analysis_id",
  {
    data_type => "integer",
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
  "source",
  { data_type => "varchar", is_nullable => 0, size => 20 },
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
  "canonical_transcript_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "canonical_annotation",
  { data_type => "varchar", is_nullable => 1, size => 255 },
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
__PACKAGE__->set_primary_key("gene_id");

=head1 RELATIONS

=head2 alt_allele

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::AltAllele>

=cut

__PACKAGE__->might_have(
  "alt_allele",
  "Grm::DBIC::Ensembl::Result::AltAllele",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
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
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
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

=head2 canonical_transcript

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "canonical_transcript",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "canonical_transcript_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 gene_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::GeneAttrib>

=cut

__PACKAGE__->has_many(
  "gene_attribs",
  "Grm::DBIC::Ensembl::Result::GeneAttrib",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 operon_transcript_genes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::OperonTranscriptGene>

=cut

__PACKAGE__->has_many(
  "operon_transcript_genes",
  "Grm::DBIC::Ensembl::Result::OperonTranscriptGene",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 splicing_events

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingEvent>

=cut

__PACKAGE__->has_many(
  "splicing_events",
  "Grm::DBIC::Ensembl::Result::SplicingEvent",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->has_many(
  "transcripts",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unconventional_transcript_associations

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::UnconventionalTranscriptAssociation>

=cut

__PACKAGE__->has_many(
  "unconventional_transcript_associations",
  "Grm::DBIC::Ensembl::Result::UnconventionalTranscriptAssociation",
  { "foreign.gene_id" => "self.gene_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6R2xaFS5BQ+SEDUJH4Hfdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
