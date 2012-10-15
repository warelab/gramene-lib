package Grm::DBIC::EnsemblCompara::Result::DnafragRegion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::DnafragRegion

=cut

__PACKAGE__->table("dnafrag_region");

=head1 ACCESSORS

=head2 synteny_region_id

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
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_end

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dnafrag_strand

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "synteny_region_id",
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
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "dnafrag_end",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "dnafrag_strand",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hPk9s/lvNzCcfe2E0FHnxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
