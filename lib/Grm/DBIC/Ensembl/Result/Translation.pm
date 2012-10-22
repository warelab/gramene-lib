package Grm::DBIC::Ensembl::Result::Translation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Translation

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

=head2 seq_end

  data_type: 'integer'
  is_nullable: 0

=head2 end_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

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
__PACKAGE__->set_primary_key("translation_id");

=head1 RELATIONS

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

=head2 transcript

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->might_have(
  "transcript",
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
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 start_exon

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Exon>

=cut

__PACKAGE__->belongs_to(
  "start_exon",
  "Grm::DBIC::Ensembl::Result::Exon",
  { exon_id => "start_exon_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 transcript

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "transcript",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "transcript_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hAnz5los1xwwt0kZZkq8Lg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
