use utf8;
package Grm::DBIC::Ensembl::Result::Translation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Translation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<translation>

=cut

__PACKAGE__->table("translation");

=head1 ACCESSORS

=head2 translation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_start

  data_type: 'integer'
  is_nullable: 0

=head2 start_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

relative to exon start

=head2 seq_end

  data_type: 'integer'
  is_nullable: 0

=head2 end_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

relative to exon start

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 version

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 created_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 modified_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "translation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "transcript_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_start",
  { data_type => "integer", is_nullable => 0 },
  "start_exon_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_end",
  { data_type => "integer", is_nullable => 0 },
  "end_exon_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "version",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "created_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "modified_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</translation_id>

=back

=cut

__PACKAGE__->set_primary_key("translation_id");

=head1 RELATIONS

=head2 active_transcript

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->might_have(
  "active_transcript",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { "foreign.canonical_translation_id" => "self.translation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 end_exon

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Exon>

=cut

__PACKAGE__->belongs_to(
  "end_exon",
  "Grm::DBIC::Ensembl::Result::Exon",
  { exon_id => "end_exon_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 protein_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ProteinFeature>

=cut

__PACKAGE__->has_many(
  "protein_features",
  "Grm::DBIC::Ensembl::Result::ProteinFeature",
  { "foreign.translation_id" => "self.translation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 start_exon

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Exon>

=cut

__PACKAGE__->belongs_to(
  "start_exon",
  "Grm::DBIC::Ensembl::Result::Exon",
  { exon_id => "start_exon_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

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

=head2 translation_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::TranslationAttrib>

=cut

__PACKAGE__->has_many(
  "translation_attribs",
  "Grm::DBIC::Ensembl::Result::TranslationAttrib",
  { "foreign.translation_id" => "self.translation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p1d3DwraVA+v3YTzX4F3DA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
