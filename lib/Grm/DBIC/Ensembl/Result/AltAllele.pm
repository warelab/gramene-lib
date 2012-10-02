package Grm::DBIC::Ensembl::Result::AltAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::AltAllele

=cut

__PACKAGE__->table("alt_allele");

=head1 ACCESSORS

=head2 alt_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 is_ref

  data_type: 'enum'
  default_value: 0
  extra: {list => [0,1]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "alt_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "gene_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "is_ref",
  {
    data_type => "enum",
    default_value => 0,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
);
__PACKAGE__->add_unique_constraint("allele_idx", ["alt_allele_id", "gene_id"]);
__PACKAGE__->add_unique_constraint("gene_idx", ["gene_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:niLZLrUBErQ8U204bd042A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
