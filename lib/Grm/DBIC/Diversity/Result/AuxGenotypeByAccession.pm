package Grm::DBIC::Diversity::Result::AuxGenotypeByAccession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxGenotypeByAccession

=cut

__PACKAGE__->table("aux_genotype_by_accession");

=head1 ACCESSORS

=head2 aux_genotype_by_accession_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_marker_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 aux_map_info_id

  data_type: 'integer'
  is_nullable: 1

=head2 marker_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 chr

  data_type: 'integer'
  is_nullable: 1

=head2 chr_start

  data_type: 'integer'
  is_nullable: 1

=head2 cdv_map_feature_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 feature_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 div_allele_assay_id

  data_type: 'integer'
  is_nullable: 1

=head2 scoring_tech_group

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 marker_type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 genotype_string

  data_type: 'text'
  is_nullable: 1

=head2 sorted_genotype

  data_type: 'text'
  is_nullable: 1

=head2 formatted_genotype

  data_type: 'text'
  is_nullable: 1

=head2 resolved_genotype

  data_type: 'text'
  is_nullable: 1

=head2 allele_count

  data_type: 'integer'
  is_nullable: 1

=head2 div_obs_unit_id

  data_type: 'integer'
  is_nullable: 1

=head2 accename

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 sampstat

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 genus

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 subspecies

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "aux_genotype_by_accession_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cdv_marker_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "aux_map_info_id",
  { data_type => "integer", is_nullable => 1 },
  "marker_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "chr",
  { data_type => "integer", is_nullable => 1 },
  "chr_start",
  { data_type => "integer", is_nullable => 1 },
  "cdv_map_feature_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "feature_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "div_allele_assay_id",
  { data_type => "integer", is_nullable => 1 },
  "scoring_tech_group",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "genotype_string",
  { data_type => "text", is_nullable => 1 },
  "sorted_genotype",
  { data_type => "text", is_nullable => 1 },
  "formatted_genotype",
  { data_type => "text", is_nullable => 1 },
  "resolved_genotype",
  { data_type => "text", is_nullable => 1 },
  "allele_count",
  { data_type => "integer", is_nullable => 1 },
  "div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "accename",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "sampstat",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "subspecies",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);
__PACKAGE__->set_primary_key("aux_genotype_by_accession_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YKnbKh3YGlmFrpeHNDU68A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
