package Grm::DBIC::EnsemblCompara::Result::GenomicAlign8760;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::GenomicAlign8760

=cut

__PACKAGE__->table("genomic_align_8760");

=head1 ACCESSORS

=head2 genomic_align_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 genomic_align_block_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 method_link_species_set_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_start

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dnafrag_end

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dnafrag_strand

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 cigar_line

  data_type: 'mediumtext'
  is_nullable: 1

=head2 visible

  data_type: 'tinyint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 node_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "genomic_align_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "genomic_align_block_id",
  { data_type => "bigint", extra => { unsigned => 1 }, is_nullable => 0 },
  "method_link_species_set_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "dnafrag_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "dnafrag_start",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dnafrag_end",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dnafrag_strand",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "cigar_line",
  { data_type => "mediumtext", is_nullable => 1 },
  "visible",
  {
    data_type => "tinyint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "node_id",
  { data_type => "bigint", extra => { unsigned => 1 }, is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:itEBetQoF6SuH8p/WBTObQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
