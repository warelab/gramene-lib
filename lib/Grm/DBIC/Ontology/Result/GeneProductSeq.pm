package Grm::DBIC::Ontology::Result::GeneProductSeq;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::GeneProductSeq

=cut

__PACKAGE__->table("gene_product_seq");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 seq_id

  data_type: 'integer'
  is_nullable: 0

=head2 is_primary_seq

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "seq_id",
  { data_type => "integer", is_nullable => 0 },
  "is_primary_seq",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-15 12:46:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4OXhtzPiZNpgCDJfY2sk9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
