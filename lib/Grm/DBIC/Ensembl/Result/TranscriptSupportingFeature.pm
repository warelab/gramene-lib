use utf8;
package Grm::DBIC::Ensembl::Result::TranscriptSupportingFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::TranscriptSupportingFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<transcript_supporting_feature>

=cut

__PACKAGE__->table("transcript_supporting_feature");

=head1 ACCESSORS

=head2 transcript_supporting_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 transcript_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature_type

  data_type: 'enum'
  extra: {list => ["dna_align_feature","protein_align_feature"]}
  is_nullable: 1

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "transcript_supporting_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "transcript_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature_type",
  {
    data_type => "enum",
    extra => { list => ["dna_align_feature", "protein_align_feature"] },
    is_nullable => 1,
  },
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</transcript_supporting_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("transcript_supporting_feature_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<all_idx>

=over 4

=item * L</transcript_id>

=item * L</feature_type>

=item * L</feature_id>

=back

=cut

__PACKAGE__->add_unique_constraint("all_idx", ["transcript_id", "feature_type", "feature_id"]);

=head1 RELATIONS

=head2 transcript

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "transcript",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "transcript_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a3j2yUQufdIH+FjC7IUESA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
