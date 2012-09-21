package Grm::DBIC::DiversityMaize::Result::AuxGenotypeByAccessionCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxGenotypeByAccessionCount

=cut

__PACKAGE__->table("aux_genotype_by_accession_count");

=head1 ACCESSORS

=head2 aux_genotype_by_accession_count_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 accename1

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 accename2

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 marker_type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 count_accename

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_genotype_by_accession_count_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "accename1",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "accename2",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "marker_type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "count_accename",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_genotype_by_accession_count_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GVgvzwyNNfM891GQRI+8DA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
