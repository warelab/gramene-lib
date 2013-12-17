use utf8;
package Grm::DBIC::Ensembl::Result::IntronSupportingEvidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::IntronSupportingEvidence

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<intron_supporting_evidence>

=cut

__PACKAGE__->table("intron_supporting_evidence");

=head1 ACCESSORS

=head2 intron_supporting_evidence_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 hit_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 score

  data_type: 'decimal'
  is_nullable: 1
  size: [10,3]

=head2 score_type

  data_type: 'enum'
  default_value: 'NONE'
  extra: {list => ["NONE","DEPTH"]}
  is_nullable: 1

=head2 is_splice_canonical

  data_type: 'enum'
  default_value: 0
  extra: {list => [0,1]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "intron_supporting_evidence_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "analysis_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "hit_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "score",
  { data_type => "decimal", is_nullable => 1, size => [10, 3] },
  "score_type",
  {
    data_type => "enum",
    default_value => "NONE",
    extra => { list => ["NONE", "DEPTH"] },
    is_nullable => 1,
  },
  "is_splice_canonical",
  {
    data_type => "enum",
    default_value => 0,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</intron_supporting_evidence_id>

=back

=cut

__PACKAGE__->set_primary_key("intron_supporting_evidence_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<analysis_id_2>

=over 4

=item * L</analysis_id>

=item * L</seq_region_id>

=item * L</seq_region_start>

=item * L</seq_region_end>

=item * L</seq_region_strand>

=item * L</hit_name>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "analysis_id_2",
  [
    "analysis_id",
    "seq_region_id",
    "seq_region_start",
    "seq_region_end",
    "seq_region_strand",
    "hit_name",
  ],
);

=head1 RELATIONS

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F58eUOYGT99/yJtqa4820g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
