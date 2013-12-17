use utf8;
package Grm::DBIC::Ensembl::Result::Assembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Assembly

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<assembly>

=cut

__PACKAGE__->table("assembly");

=head1 ACCESSORS

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

=head1 UNIQUE CONSTRAINTS

=head2 C<all_idx>

=over 4

=item * L</asm_seq_region_id>

=item * L</cmp_seq_region_id>

=item * L</asm_start>

=item * L</asm_end>

=item * L</cmp_start>

=item * L</cmp_end>

=item * L</ori>

=back

=cut

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
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 cmp_seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "cmp_seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "cmp_seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tj+J11cQHaUV4F7xcTWUeg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
