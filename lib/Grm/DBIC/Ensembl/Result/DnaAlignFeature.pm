package Grm::DBIC::Ensembl::Result::DnaAlignFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::DnaAlignFeature

=cut

__PACKAGE__->table("dna_align_feature");

=head1 ACCESSORS

=head2 dna_align_feature_id

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

=head2 hit_start

  data_type: 'integer'
  is_nullable: 0

=head2 hit_end

  data_type: 'integer'
  is_nullable: 0

=head2 hit_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 hit_name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=head2 evalue

  data_type: 'double precision'
  is_nullable: 1

=head2 perc_ident

  data_type: 'float'
  is_nullable: 1

=head2 cigar_line

  data_type: 'text'
  is_nullable: 1

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 hcoverage

  data_type: 'double precision'
  is_nullable: 1

=head2 external_data

  data_type: 'text'
  is_nullable: 1

=head2 pair_dna_align_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "dna_align_feature_id",
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
  "hit_start",
  { data_type => "integer", is_nullable => 0 },
  "hit_end",
  { data_type => "integer", is_nullable => 0 },
  "hit_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "hit_name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "score",
  { data_type => "double precision", is_nullable => 1 },
  "evalue",
  { data_type => "double precision", is_nullable => 1 },
  "perc_ident",
  { data_type => "float", is_nullable => 1 },
  "cigar_line",
  { data_type => "text", is_nullable => 1 },
  "external_db_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "hcoverage",
  { data_type => "double precision", is_nullable => 1 },
  "external_data",
  { data_type => "text", is_nullable => 1 },
  "pair_dna_align_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("dna_align_feature_id");

=head1 RELATIONS

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

=head2 external_db

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::ExternalDb>

=cut

__PACKAGE__->belongs_to(
  "external_db",
  "Grm::DBIC::Ensembl::Result::ExternalDb",
  { external_db_id => "external_db_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 pair_dna_align_feature

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::DnaAlignFeature>

=cut

__PACKAGE__->belongs_to(
  "pair_dna_align_feature",
  "Grm::DBIC::Ensembl::Result::DnaAlignFeature",
  { dna_align_feature_id => "pair_dna_align_feature_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 dna_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DnaAlignFeature>

=cut

__PACKAGE__->has_many(
  "dna_align_features",
  "Grm::DBIC::Ensembl::Result::DnaAlignFeature",
  {
    "foreign.pair_dna_align_feature_id" => "self.dna_align_feature_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HG9FwSPOuD+YLa0BfvZb/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
