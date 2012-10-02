package Grm::DBIC::Diversity::Result::DivTreatmentUom;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::DivTreatmentUom

=cut

__PACKAGE__->table("div_treatment_uom");

=head1 ACCESSORS

=head2 div_treatment_uom_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 eo_accession

  data_type: 'integer'
  is_nullable: 1

=head2 div_unit_of_measure_id

  data_type: 'integer'
  is_nullable: 1

=head2 local_treatment_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 treatment_protocol

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "div_treatment_uom_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "eo_accession",
  { data_type => "integer", is_nullable => 1 },
  "div_unit_of_measure_id",
  { data_type => "integer", is_nullable => 1 },
  "local_treatment_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "treatment_protocol",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("div_treatment_uom_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YakrvvTvRe1kd6gMAbsfhA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
