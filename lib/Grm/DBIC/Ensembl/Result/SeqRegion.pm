use utf8;
package Grm::DBIC::Ensembl::Result::SeqRegion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::SeqRegion

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_region>

=cut

__PACKAGE__->table("seq_region");

=head1 ACCESSORS

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 coord_system_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 length

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "coord_system_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "length",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_region_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_region_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_cs_idx>

=over 4

=item * L</name>

=item * L</coord_system_id>

=back

=cut

__PACKAGE__->add_unique_constraint("name_cs_idx", ["name", "coord_system_id"]);

=head1 RELATIONS

=head2 assembly_asm_seq_regions

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Assembly>

=cut

__PACKAGE__->has_many(
  "assembly_asm_seq_regions",
  "Grm::DBIC::Ensembl::Result::Assembly",
  { "foreign.asm_seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 assembly_cmp_seq_regions

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Assembly>

=cut

__PACKAGE__->has_many(
  "assembly_cmp_seq_regions",
  "Grm::DBIC::Ensembl::Result::Assembly",
  { "foreign.cmp_seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 assembly_exception_exc_seq_regions

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::AssemblyException>

=cut

__PACKAGE__->has_many(
  "assembly_exception_exc_seq_regions",
  "Grm::DBIC::Ensembl::Result::AssemblyException",
  { "foreign.exc_seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 assembly_exception_seq_regions

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::AssemblyException>

=cut

__PACKAGE__->has_many(
  "assembly_exception_seq_regions",
  "Grm::DBIC::Ensembl::Result::AssemblyException",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 coord_system

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::CoordSystem>

=cut

__PACKAGE__->belongs_to(
  "coord_system",
  "Grm::DBIC::Ensembl::Result::CoordSystem",
  { coord_system_id => "coord_system_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 density_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DensityFeature>

=cut

__PACKAGE__->has_many(
  "density_features",
  "Grm::DBIC::Ensembl::Result::DensityFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ditag_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DitagFeature>

=cut

__PACKAGE__->has_many(
  "ditag_features",
  "Grm::DBIC::Ensembl::Result::DitagFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dna

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::Dna>

=cut

__PACKAGE__->might_have(
  "dna",
  "Grm::DBIC::Ensembl::Result::Dna",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dna_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DnaAlignFeature>

=cut

__PACKAGE__->has_many(
  "dna_align_features",
  "Grm::DBIC::Ensembl::Result::DnaAlignFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dnac

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::Dnac>

=cut

__PACKAGE__->might_have(
  "dnac",
  "Grm::DBIC::Ensembl::Result::Dnac",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 exons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Exon>

=cut

__PACKAGE__->has_many(
  "exons",
  "Grm::DBIC::Ensembl::Result::Exon",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->has_many(
  "genes",
  "Grm::DBIC::Ensembl::Result::Gene",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 karyotypes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Karyotype>

=cut

__PACKAGE__->has_many(
  "karyotypes",
  "Grm::DBIC::Ensembl::Result::Karyotype",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 marker_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerFeature>

=cut

__PACKAGE__->has_many(
  "marker_features",
  "Grm::DBIC::Ensembl::Result::MarkerFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 misc_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MiscFeature>

=cut

__PACKAGE__->has_many(
  "misc_features",
  "Grm::DBIC::Ensembl::Result::MiscFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 operon_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::OperonTranscript>

=cut

__PACKAGE__->has_many(
  "operon_transcripts",
  "Grm::DBIC::Ensembl::Result::OperonTranscript",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 operons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Operon>

=cut

__PACKAGE__->has_many(
  "operons",
  "Grm::DBIC::Ensembl::Result::Operon",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 prediction_exons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::PredictionExon>

=cut

__PACKAGE__->has_many(
  "prediction_exons",
  "Grm::DBIC::Ensembl::Result::PredictionExon",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 prediction_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::PredictionTranscript>

=cut

__PACKAGE__->has_many(
  "prediction_transcripts",
  "Grm::DBIC::Ensembl::Result::PredictionTranscript",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 protein_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ProteinAlignFeature>

=cut

__PACKAGE__->has_many(
  "protein_align_features",
  "Grm::DBIC::Ensembl::Result::ProteinAlignFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::QtlFeature>

=cut

__PACKAGE__->has_many(
  "qtl_features",
  "Grm::DBIC::Ensembl::Result::QtlFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 repeat_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::RepeatFeature>

=cut

__PACKAGE__->has_many(
  "repeat_features",
  "Grm::DBIC::Ensembl::Result::RepeatFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_region_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegionAttrib>

=cut

__PACKAGE__->has_many(
  "seq_region_attribs",
  "Grm::DBIC::Ensembl::Result::SeqRegionAttrib",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_region_mappings

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegionMapping>

=cut

__PACKAGE__->has_many(
  "seq_region_mappings",
  "Grm::DBIC::Ensembl::Result::SeqRegionMapping",
  { "foreign.internal_seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 simple_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SimpleFeature>

=cut

__PACKAGE__->has_many(
  "simple_features",
  "Grm::DBIC::Ensembl::Result::SimpleFeature",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 splicing_events

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SplicingEvent>

=cut

__PACKAGE__->has_many(
  "splicing_events",
  "Grm::DBIC::Ensembl::Result::SplicingEvent",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->has_many(
  "transcripts",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { "foreign.seq_region_id" => "self.seq_region_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1b+ZzwNlVYO2Vdyi9g9x/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
