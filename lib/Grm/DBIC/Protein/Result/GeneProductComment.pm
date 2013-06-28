package Grm::DBIC::Protein::Result::GeneProductComment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::GeneProductComment

=cut

__PACKAGE__->table("gene_product_comment");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 public_comment

  data_type: 'text'
  is_nullable: 1

=head2 curator_comment

  data_type: 'text'
  is_nullable: 1

=head2 p_comment_curation_date

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 c_comment_curation_date

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "public_comment",
  { data_type => "text", is_nullable => 1 },
  "curator_comment",
  { data_type => "text", is_nullable => 1 },
  "p_comment_curation_date",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "c_comment_curation_date",
  { data_type => "varchar", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("gene_product_id");

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ga/LyNa60TW+kCUpAdLs/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
