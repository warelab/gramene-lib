package Grm::DBIC::DiversityArabidopsis::Result::GrmAlleleAssay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::GrmAlleleAssay

=cut

__PACKAGE__->table("grm_allele_assay");

=head1 ACCESSORS

=head2 div_experiment_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 div_allele_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=head2 number

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_experiment_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "div_allele_assay_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 25 },
  "number",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qrsf2Z95U3rrQets52ojSQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
