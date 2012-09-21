package Grm::DBIC::DiversityMaize::Result::AuxAssayPlantGenotypeCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxAssayPlantGenotypeCount

=cut

__PACKAGE__->table("aux_assay_plant_genotype_count");

=head1 ACCESSORS

=head2 aux_assay_plant_genotype_count_id

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

=head2 count_latitude

  data_type: 'integer'
  is_nullable: 1

=head2 count_longitude

  data_type: 'integer'
  is_nullable: 1

=head2 count_invalid

  data_type: 'integer'
  is_nullable: 1

=head2 count_valid

  data_type: 'integer'
  is_nullable: 1

=head2 count_all

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_assay_plant_genotype_count_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "marker_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "feature_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "count_latitude",
  { data_type => "integer", is_nullable => 1 },
  "count_longitude",
  { data_type => "integer", is_nullable => 1 },
  "count_invalid",
  { data_type => "integer", is_nullable => 1 },
  "count_valid",
  { data_type => "integer", is_nullable => 1 },
  "count_all",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_assay_plant_genotype_count_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Oy7K64s9sVhBdXE6P0d1+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
