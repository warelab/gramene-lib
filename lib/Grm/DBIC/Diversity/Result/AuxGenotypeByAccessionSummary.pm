package Grm::DBIC::Diversity::Result::AuxGenotypeByAccessionSummary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxGenotypeByAccessionSummary

=cut

__PACKAGE__->table("aux_genotype_by_accession_summary");

=head1 ACCESSORS

=head2 aux_genotype_by_accession_summary_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 marker_type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

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
  "aux_genotype_by_accession_summary_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
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
__PACKAGE__->set_primary_key("aux_genotype_by_accession_summary_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RwjF2DljnnT/SAyapZWqqw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
