package Grm::DBIC::AmigoGo::Result::GeneProductSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoGo::Result::GeneProductSynonym

=cut

__PACKAGE__->table("gene_product_synonym");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 product_synonym

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "product_synonym",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->add_unique_constraint("gene_product_id", ["gene_product_id", "product_synonym"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XhXWlb6dUwWVbEHNTfOGJA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
