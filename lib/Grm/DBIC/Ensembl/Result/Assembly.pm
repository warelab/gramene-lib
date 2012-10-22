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

=head2 assembly_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 asm_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 cmp_seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  "assembly_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "asm_seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "cmp_seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
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
__PACKAGE__->set_primary_key("assembly_id");
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

=head1 RELATIONS

=head2 asm_seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "asm_seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "asm_seq_region_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 cmp_seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "cmp_seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "cmp_seq_region_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:elZTV+Bvp8GcahgDWQkM4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
