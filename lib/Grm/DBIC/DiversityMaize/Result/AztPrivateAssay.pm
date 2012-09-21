package Grm::DBIC::DiversityMaize::Result::AztPrivateAssay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AztPrivateAssay

=cut

__PACKAGE__->table("azt_private_assay");

=head1 ACCESSORS

=head2 azt_private_assay_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_assay_id

  data_type: 'integer'
  is_nullable: 1

=head2 private_allele

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 private_assay

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 azt_funding_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "azt_private_assay_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "div_allele_assay_id",
  { data_type => "integer", is_nullable => 1 },
  "private_allele",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "private_assay",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "azt_funding_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("azt_private_assay_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GlNW0gb75Ih5A6p7YUYSDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
