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

=head2 previous_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 next_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
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

=cut

__PACKAGE__->add_columns(
  "intron_supporting_evidence_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "previous_exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "next_exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
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
);

=head1 PRIMARY KEY

=over 4

=item * L</intron_supporting_evidence_id>

=back

=cut

__PACKAGE__->set_primary_key("intron_supporting_evidence_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<previous_exon_id>

=over 4

=item * L</previous_exon_id>

=item * L</next_exon_id>

=back

=cut

__PACKAGE__->add_unique_constraint("previous_exon_id", ["previous_exon_id", "next_exon_id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+fFoJklJ/uVrCdZZZtq3+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
