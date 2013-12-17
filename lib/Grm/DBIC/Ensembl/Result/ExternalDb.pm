use utf8;
package Grm::DBIC::Ensembl::Result::ExternalDb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::ExternalDb

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<external_db>

=cut

__PACKAGE__->table("external_db");

=head1 ACCESSORS

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 db_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 db_release

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'enum'
  extra: {list => ["KNOWNXREF","KNOWN","XREF","PRED","ORTH","PSEUDO"]}
  is_nullable: 0

=head2 priority

  data_type: 'integer'
  is_nullable: 0

=head2 db_display_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 type

  data_type: 'enum'
  extra: {list => ["ARRAY","ALT_TRANS","ALT_GENE","MISC","LIT","PRIMARY_DB_SYNONYM","ENSEMBL"]}
  is_nullable: 1

=head2 secondary_db_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 secondary_db_table

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "external_db_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "db_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "db_release",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "status",
  {
    data_type => "enum",
    extra => {
      list => ["KNOWNXREF", "KNOWN", "XREF", "PRED", "ORTH", "PSEUDO"],
    },
    is_nullable => 0,
  },
  "priority",
  { data_type => "integer", is_nullable => 0 },
  "db_display_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "type",
  {
    data_type => "enum",
    extra => {
      list => [
        "ARRAY",
        "ALT_TRANS",
        "ALT_GENE",
        "MISC",
        "LIT",
        "PRIMARY_DB_SYNONYM",
        "ENSEMBL",
      ],
    },
    is_nullable => 1,
  },
  "secondary_db_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "secondary_db_table",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</external_db_id>

=back

=cut

__PACKAGE__->set_primary_key("external_db_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<db_name_db_release_idx>

=over 4

=item * L</db_name>

=item * L</db_release>

=back

=cut

__PACKAGE__->add_unique_constraint("db_name_db_release_idx", ["db_name", "db_release"]);

=head1 RELATIONS

=head2 dna_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DnaAlignFeature>

=cut

__PACKAGE__->has_many(
  "dna_align_features",
  "Grm::DBIC::Ensembl::Result::DnaAlignFeature",
  { "foreign.external_db_id" => "self.external_db_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 protein_align_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::ProteinAlignFeature>

=cut

__PACKAGE__->has_many(
  "protein_align_features",
  "Grm::DBIC::Ensembl::Result::ProteinAlignFeature",
  { "foreign.external_db_id" => "self.external_db_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unmapped_objects

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::UnmappedObject>

=cut

__PACKAGE__->has_many(
  "unmapped_objects",
  "Grm::DBIC::Ensembl::Result::UnmappedObject",
  { "foreign.external_db_id" => "self.external_db_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::Xref>

=cut

__PACKAGE__->has_many(
  "xrefs",
  "Grm::DBIC::Ensembl::Result::Xref",
  { "foreign.external_db_id" => "self.external_db_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 16:58:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3XfhXPMdOZ9Bdz/sHKtJwQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
