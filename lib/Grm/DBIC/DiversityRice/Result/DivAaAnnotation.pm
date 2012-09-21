package Grm::DBIC::DiversityRice::Result::DivAaAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::DivAaAnnotation

=cut

__PACKAGE__->table("div_aa_annotation");

=head1 ACCESSORS

=head2 div_aa_annotation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_aa_annotation_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_annotation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_allele_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 annotation_value

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_aa_annotation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_aa_annotation_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_annotation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_allele_assay_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "annotation_value",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_aa_annotation_id");
__PACKAGE__->add_unique_constraint("div_aa_annotation_acc", ["div_aa_annotation_acc"]);

=head1 RELATIONS

=head2 div_annotation_type

Type: belongs_to

Related object: L<Grm::DBIC::DiversityRice::Result::DivAnnotationType>

=cut

__PACKAGE__->belongs_to(
  "div_annotation_type",
  "Grm::DBIC::DiversityRice::Result::DivAnnotationType",
  { div_annotation_type_id => "div_annotation_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_allele_assay

Type: belongs_to

Related object: L<Grm::DBIC::DiversityRice::Result::DivAlleleAssay>

=cut

__PACKAGE__->belongs_to(
  "div_allele_assay",
  "Grm::DBIC::DiversityRice::Result::DivAlleleAssay",
  { div_allele_assay_id => "div_allele_assay_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HWUqua1Z9V4XsX5GiEveCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
