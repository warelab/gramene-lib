package Grm::DBIC::Protein::Result::Association;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Association

=cut

__PACKAGE__->table("association");

=head1 ACCESSORS

=head2 association_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 term_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 16

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term_type

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 is_not

  data_type: 'tinyint'
  is_nullable: 1

=head2 role_group

  data_type: 'integer'
  is_nullable: 1

=head2 assocdate

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "association_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "term_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 16 },
  "gene_product_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term_type",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "is_not",
  { data_type => "tinyint", is_nullable => 1 },
  "role_group",
  { data_type => "integer", is_nullable => 1 },
  "assocdate",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("association_id");
__PACKAGE__->add_unique_constraint("term_accession", ["term_accession", "gene_product_id"]);

=head1 RELATIONS

=head2 gene_product

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::GeneProduct>

=cut

__PACKAGE__->belongs_to(
  "gene_product",
  "Grm::DBIC::Protein::Result::GeneProduct",
  { gene_product_id => "gene_product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 evidences

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::Evidence>

=cut

__PACKAGE__->has_many(
  "evidences",
  "Grm::DBIC::Protein::Result::Evidence",
  { "foreign.association_id" => "self.association_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vMbS9qjEvnoipXY/Yjv+8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
