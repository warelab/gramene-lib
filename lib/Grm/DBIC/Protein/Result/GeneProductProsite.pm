package Grm::DBIC::Protein::Result::GeneProductProsite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::GeneProductProsite

=cut

__PACKAGE__->table("gene_product_prosite");

=head1 ACCESSORS

=head2 gene_product_prosite_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 prosite_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 prosite_desc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 prosite_sequence

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gene_product_prosite_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene_product_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "prosite_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "prosite_desc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "prosite_sequence",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("gene_product_prosite_id");

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C5/a/2Xh43iSyY/HYCb+CA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
