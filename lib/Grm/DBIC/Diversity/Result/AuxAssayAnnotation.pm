package Grm::DBIC::Diversity::Result::AuxAssayAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxAssayAnnotation

=cut

__PACKAGE__->table("aux_assay_annotations");

=head1 ACCESSORS

=head2 aux_assay_annotations_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_assay_id

  data_type: 'integer'
  is_nullable: 1

=head2 primer1

  data_type: 'text'
  is_nullable: 1

=head2 primer2

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_assay_annotations_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "div_allele_assay_id",
  { data_type => "integer", is_nullable => 1 },
  "primer1",
  { data_type => "text", is_nullable => 1 },
  "primer2",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_assay_annotations_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H9fwQe5GhBG1M2orDtuF/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
