package Grm::DBIC::Ensembl::Result::Assembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Assembly

=cut

__PACKAGE__->table("assembly");

=head1 ACCESSORS

=head2 asm_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cmp_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 asm_start

  data_type: 'integer'
  is_nullable: 0

=head2 asm_end

  data_type: 'integer'
  is_nullable: 0

=head2 cmp_start

  data_type: 'integer'
  is_nullable: 0

=head2 cmp_end

  data_type: 'integer'
  is_nullable: 0

=head2 ori

  data_type: 'tinyint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "asm_seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cmp_seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "asm_start",
  { data_type => "integer", is_nullable => 0 },
  "asm_end",
  { data_type => "integer", is_nullable => 0 },
  "cmp_start",
  { data_type => "integer", is_nullable => 0 },
  "cmp_end",
  { data_type => "integer", is_nullable => 0 },
  "ori",
  { data_type => "tinyint", is_nullable => 0 },
);
__PACKAGE__->add_unique_constraint(
  "all_idx",
  [
    "asm_seq_region_id",
    "cmp_seq_region_id",
    "asm_start",
    "asm_end",
    "cmp_start",
    "cmp_end",
    "ori",
  ],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XfusvneowMD3f8faaBdONg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
