package Grm::DBIC::Genes::Result::GeneObjectToGermplasm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneObjectToGermplasm

=cut

__PACKAGE__->table("gene_object_to_germplasm");

=head1 ACCESSORS

=head2 object_to_germplasm_id

  data_type: 'integer'
  is_auto_increment: 1
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

=head2 germplasm_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "object_to_germplasm_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "object_table",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "object_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "germplasm_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("object_to_germplasm_id");
__PACKAGE__->add_unique_constraint("object_table", ["object_table", "object_id", "germplasm_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OxKYZ02MYZM+QHATgGnYaw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
