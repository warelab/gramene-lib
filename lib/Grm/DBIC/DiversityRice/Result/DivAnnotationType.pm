package Grm::DBIC::DiversityRice::Result::DivAnnotationType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::DivAnnotationType

=cut

__PACKAGE__->table("div_annotation_type");

=head1 ACCESSORS

=head2 div_annotation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_annotation_type_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 anno_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_annotation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_annotation_type_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "anno_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_annotation_type_id");

=head1 RELATIONS

=head2 div_aa_annotations

Type: has_many

Related object: L<Grm::DBIC::DiversityRice::Result::DivAaAnnotation>

=cut

__PACKAGE__->has_many(
  "div_aa_annotations",
  "Grm::DBIC::DiversityRice::Result::DivAaAnnotation",
  {
    "foreign.div_annotation_type_id" => "self.div_annotation_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Az6iW++Fcb2nm6Y10QyVMA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
