package Grm::DBIC::OntologyTax::Result::Association;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyTax::Result::Association

=cut

__PACKAGE__->table("association");

=head1 ACCESSORS

=head2 association_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 object_class

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 is_not

  data_type: 'tinyint'
  is_nullable: 1

=head2 role_group

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "association_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "gene_product_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "object_class",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "is_not",
  { data_type => "tinyint", is_nullable => 1 },
  "role_group",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("association_id");

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::OntologyTax::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::OntologyTax::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6/LqGwkccJ7VmDygwHY3Dg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
