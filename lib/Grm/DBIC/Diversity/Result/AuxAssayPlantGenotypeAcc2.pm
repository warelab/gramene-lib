package Grm::DBIC::Diversity::Result::AuxAssayPlantGenotypeAcc2;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxAssayPlantGenotypeAcc2

=cut

__PACKAGE__->table("aux_assay_plant_genotype_acc2");

=head1 ACCESSORS

=head2 aux_assay_plant_genotype_acc_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 accename

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 germplasm_type

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 species_name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 data_count

  data_type: 'integer'
  is_nullable: 1

=head2 half_data_count

  data_type: 'integer'
  is_nullable: 1

=head2 half_data_count_rounded

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "aux_assay_plant_genotype_acc_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "accename",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "germplasm_type",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "species_name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "data_count",
  { data_type => "integer", is_nullable => 1 },
  "half_data_count",
  { data_type => "integer", is_nullable => 1 },
  "half_data_count_rounded",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);
__PACKAGE__->set_primary_key("aux_assay_plant_genotype_acc_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jQo+c1zhdXlul3TmzVsXGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
