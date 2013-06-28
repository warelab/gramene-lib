package Grm::DBIC::Genes::Result::GeneDbxrefToObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneDbxrefToObject

=cut

__PACKAGE__->table("gene_dbxref_to_object");

=head1 ACCESSORS

=head2 dbxref_to_object_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 record_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 dbxref_value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 display_label

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "dbxref_to_object_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "table_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "record_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dbxref_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "dbxref_value",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "display_label",
  { data_type => "varchar", is_nullable => 1, size => 128 },
);
__PACKAGE__->set_primary_key("dbxref_to_object_id");

=head1 RELATIONS

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneDbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::Genes::Result::GeneDbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DYDVoO4FU7YhykRdXaXpSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
