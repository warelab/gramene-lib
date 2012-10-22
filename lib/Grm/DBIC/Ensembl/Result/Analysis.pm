package Grm::DBIC::Ensembl::Result::Analysis;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Analysis

=cut

__PACKAGE__->table("analysis");

=head1 ACCESSORS

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 logic_name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 db

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 db_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 db_file

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 program

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 program_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 program_file

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 parameters

  data_type: 'text'
  is_nullable: 1

=head2 module

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 module_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 gff_source

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 gff_feature

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "logic_name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "db",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "db_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "db_file",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "program",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "program_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "program_file",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "parameters",
  { data_type => "text", is_nullable => 1 },
  "module",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "module_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "gff_source",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "gff_feature",
  { data_type => "varchar", is_nullable => 1, size => 40 },
);
__PACKAGE__->set_primary_key("analysis_id");
__PACKAGE__->add_unique_constraint("logic_name_idx", ["logic_name"]);

=head1 RELATIONS

=head2 analysis_description

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::AnalysisDescription>

=cut

__PACKAGE__->might_have(
  "analysis_description",
  "Grm::DBIC::Ensembl::Result::AnalysisDescription",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 datas_file

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DataFile>

=cut

__PACKAGE__->has_many(
  "datas_file",
  "Grm::DBIC::Ensembl::Result::DataFile",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 density_types

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DensityType>

=cut

__PACKAGE__->has_many(
  "density_types",
  "Grm::DBIC::Ensembl::Result::DensityType",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ditag_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DitagFeature>

=cut

__PACKAGE__->has_many(
  "ditag_features",
  "Grm::DBIC::Ensembl::Result::DitagFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dna_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DnaAlignFeature>

=cut

__PACKAGE__->has_many(
  "dna_align_features",
  "Grm::DBIC::Ensembl::Result::DnaAlignFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->has_many(
  "genes",
  "Grm::DBIC::Ensembl::Result::Gene",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 marker_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MarkerFeature>

=cut

__PACKAGE__->has_many(
  "marker_features",
  "Grm::DBIC::Ensembl::Result::MarkerFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 object_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ObjectXref>

=cut

__PACKAGE__->has_many(
  "object_xrefs",
  "Grm::DBIC::Ensembl::Result::ObjectXref",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 operons

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Operon>

=cut

__PACKAGE__->has_many(
  "operons",
  "Grm::DBIC::Ensembl::Result::Operon",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 operon_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::OperonTranscript>

=cut

__PACKAGE__->has_many(
  "operon_transcripts",
  "Grm::DBIC::Ensembl::Result::OperonTranscript",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 prediction_transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::PredictionTranscript>

=cut

__PACKAGE__->has_many(
  "prediction_transcripts",
  "Grm::DBIC::Ensembl::Result::PredictionTranscript",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 protein_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ProteinAlignFeature>

=cut

__PACKAGE__->has_many(
  "protein_align_features",
  "Grm::DBIC::Ensembl::Result::ProteinAlignFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 protein_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ProteinFeature>

=cut

__PACKAGE__->has_many(
  "protein_features",
  "Grm::DBIC::Ensembl::Result::ProteinFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::QtlFeature>

=cut

__PACKAGE__->has_many(
  "qtl_features",
  "Grm::DBIC::Ensembl::Result::QtlFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 repeat_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::RepeatFeature>

=cut

__PACKAGE__->has_many(
  "repeat_features",
  "Grm::DBIC::Ensembl::Result::RepeatFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 simple_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SimpleFeature>

=cut

__PACKAGE__->has_many(
  "simple_features",
  "Grm::DBIC::Ensembl::Result::SimpleFeature",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->has_many(
  "transcripts",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unmapped_objects

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::UnmappedObject>

=cut

__PACKAGE__->has_many(
  "unmapped_objects",
  "Grm::DBIC::Ensembl::Result::UnmappedObject",
  { "foreign.analysis_id" => "self.analysis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pWYLX9psx717+cN8pH0G1A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
