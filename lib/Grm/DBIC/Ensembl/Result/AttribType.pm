use utf8;
package Grm::DBIC::Ensembl::Result::AttribType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AttribType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<attrib_type>

=cut

__PACKAGE__->table("attrib_type");

=head1 ACCESSORS

=head2 attrib_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 15

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "attrib_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 15 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attrib_type_id>

=back

=cut

__PACKAGE__->set_primary_key("attrib_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<code_idx>

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->add_unique_constraint("code_idx", ["code"]);

=head1 RELATIONS

=head2 gene_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::GeneAttrib>

=cut

__PACKAGE__->has_many(
  "gene_attribs",
  "Grm::DBIC::Ensembl::Result::GeneAttrib",
  { "foreign.attrib_type_id" => "self.attrib_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 misc_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MiscAttrib>

=cut

__PACKAGE__->has_many(
  "misc_attribs",
  "Grm::DBIC::Ensembl::Result::MiscAttrib",
  { "foreign.attrib_type_id" => "self.attrib_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_region_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegionAttrib>

=cut

__PACKAGE__->has_many(
  "seq_region_attribs",
  "Grm::DBIC::Ensembl::Result::SeqRegionAttrib",
  { "foreign.attrib_type_id" => "self.attrib_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcript_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::TranscriptAttrib>

=cut

__PACKAGE__->has_many(
  "transcript_attribs",
  "Grm::DBIC::Ensembl::Result::TranscriptAttrib",
  { "foreign.attrib_type_id" => "self.attrib_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 translation_attribs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::TranslationAttrib>

=cut

__PACKAGE__->has_many(
  "translation_attribs",
  "Grm::DBIC::Ensembl::Result::TranslationAttrib",
  { "foreign.attrib_type_id" => "self.attrib_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eV0TMTouezXXX4vhl/hpkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
