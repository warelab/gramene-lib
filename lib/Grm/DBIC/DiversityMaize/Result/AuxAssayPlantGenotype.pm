package Grm::DBIC::DiversityMaize::Result::AuxAssayPlantGenotype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxAssayPlantGenotype

=cut

__PACKAGE__->table("aux_assay_plant_genotype");

=head1 ACCESSORS

=head2 aux_assay_plant_genotype_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 marker_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 marker_type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 feature_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 state_province

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 locality_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 div_allele_assay_id

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

=head2 germplasm_type

  data_type: 'varchar'
  is_nullable: 1
  size: 200

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

=head2 species_name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 allele_value

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "aux_assay_plant_genotype_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "marker_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "feature_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "state_province",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "locality_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "div_allele_assay_id",
  { data_type => "integer", is_nullable => 1 },
  "div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "accename",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "sampstat",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "germplasm_type",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "subspecies",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "species_name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "allele_value",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);
__PACKAGE__->set_primary_key("aux_assay_plant_genotype_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M0NEC/thvsXNKlaVyTaVCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
