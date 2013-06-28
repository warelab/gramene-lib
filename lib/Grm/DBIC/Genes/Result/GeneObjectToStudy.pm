package Grm::DBIC::Genes::Result::GeneObjectToStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneObjectToStudy

=cut

__PACKAGE__->table("gene_object_to_study");

=head1 ACCESSORS

=head2 object_to_study_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 object_table

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 object_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 study_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "object_to_study_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "object_table",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "object_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "study_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);
__PACKAGE__->set_primary_key("object_to_study_id");
__PACKAGE__->add_unique_constraint("object_table", ["object_table", "object_id", "study_id"]);

=head1 RELATIONS

=head2 study

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneStudy>

=cut

__PACKAGE__->belongs_to(
  "study",
  "Grm::DBIC::Genes::Result::GeneStudy",
  { study_id => "study_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mvpVAnxosgFF6XaPC8FgJQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
