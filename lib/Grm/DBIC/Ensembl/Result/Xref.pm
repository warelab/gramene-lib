use utf8;
package Grm::DBIC::Ensembl::Result::Xref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Xref

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<xref>

=cut

__PACKAGE__->table("xref");

=head1 ACCESSORS

=head2 xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 dbprimary_acc

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 display_label

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 version

  data_type: 'varchar'
  default_value: 0
  is_nullable: 0
  size: 10

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 info_type

  data_type: 'enum'
  default_value: 'NONE'
  extra: {list => ["NONE","PROJECTION","MISC","DEPENDENT","DIRECT","SEQUENCE_MATCH","INFERRED_PAIR","PROBE","UNMAPPED","COORDINATE_OVERLAP","CHECKSUM"]}
  is_nullable: 0

=head2 info_text

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "external_db_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "dbprimary_acc",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "display_label",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "version",
  { data_type => "varchar", default_value => 0, is_nullable => 0, size => 10 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "info_type",
  {
    data_type => "enum",
    default_value => "NONE",
    extra => {
      list => [
        "NONE",
        "PROJECTION",
        "MISC",
        "DEPENDENT",
        "DIRECT",
        "SEQUENCE_MATCH",
        "INFERRED_PAIR",
        "PROBE",
        "UNMAPPED",
        "COORDINATE_OVERLAP",
        "CHECKSUM",
      ],
    },
    is_nullable => 0,
  },
  "info_text",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</xref_id>

=back

=cut

__PACKAGE__->set_primary_key("xref_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<id_index>

=over 4

=item * L</dbprimary_acc>

=item * L</external_db_id>

=item * L</info_type>

=item * L</info_text>

=item * L</version>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "id_index",
  [
    "dbprimary_acc",
    "external_db_id",
    "info_type",
    "info_text",
    "version",
  ],
);

=head1 RELATIONS

=head2 dependent_xref_dependent_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DependentXref>

=cut

__PACKAGE__->has_many(
  "dependent_xref_dependent_xrefs",
  "Grm::DBIC::Ensembl::Result::DependentXref",
  { "foreign.dependent_xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dependent_xref_master_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DependentXref>

=cut

__PACKAGE__->has_many(
  "dependent_xref_master_xrefs",
  "Grm::DBIC::Ensembl::Result::DependentXref",
  { "foreign.master_xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 external_db

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::ExternalDb>

=cut

__PACKAGE__->belongs_to(
  "external_db",
  "Grm::DBIC::Ensembl::Result::ExternalDb",
  { external_db_id => "external_db_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 external_synonyms

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ExternalSynonym>

=cut

__PACKAGE__->has_many(
  "external_synonyms",
  "Grm::DBIC::Ensembl::Result::ExternalSynonym",
  { "foreign.xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genes

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->has_many(
  "genes",
  "Grm::DBIC::Ensembl::Result::Gene",
  { "foreign.display_xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 object_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ObjectXref>

=cut

__PACKAGE__->has_many(
  "object_xrefs",
  "Grm::DBIC::Ensembl::Result::ObjectXref",
  { "foreign.xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ontology_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::OntologyXref>

=cut

__PACKAGE__->has_many(
  "ontology_xrefs",
  "Grm::DBIC::Ensembl::Result::OntologyXref",
  { "foreign.source_xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transcripts

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->has_many(
  "transcripts",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { "foreign.display_xref_id" => "self.xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FtTjTd/Nx/JQDpP76cI4Tg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
