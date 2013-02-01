package Grm::DBIC::AmigoTax::Result::GeneProductSubset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTax::Result::GeneProductSubset

=cut

__PACKAGE__->table("gene_product_subset");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 subset_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "subset_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->add_unique_constraint("gps3", ["gene_product_id", "subset_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6ZlBxekD9mk1yFqjQegdPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
