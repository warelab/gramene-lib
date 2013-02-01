package Grm::DBIC::AmigoPo::Result::GeneProductHomology;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoPo::Result::GeneProductHomology

=cut

__PACKAGE__->table("gene_product_homology");

=head1 ACCESSORS

=head2 gene_product1_id

  data_type: 'integer'
  is_nullable: 0

=head2 gene_product2_id

  data_type: 'integer'
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_product1_id",
  { data_type => "integer", is_nullable => 0 },
  "gene_product2_id",
  { data_type => "integer", is_nullable => 0 },
  "relationship_type_id",
  { data_type => "integer", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aUSKcLmmG3Go98dPVmJjYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
