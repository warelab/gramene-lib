use utf8;
package Grm::DBIC::Ensembl::Result::UnmappedObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::UnmappedObject

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<unmapped_object>

=cut

__PACKAGE__->table("unmapped_object");

=head1 ACCESSORS

=head2 unmapped_object_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["xref","cDNA","Marker"]}
  is_nullable: 0

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 unmapped_reason_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 query_score

  data_type: 'double precision'
  is_nullable: 1

=head2 target_score

  data_type: 'double precision'
  is_nullable: 1

=head2 ensembl_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 ensembl_object_type

  data_type: 'enum'
  default_value: 'RawContig'
  extra: {list => ["RawContig","Transcript","Gene","Translation"]}
  is_nullable: 1

=head2 parent

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "unmapped_object_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  {
    data_type => "enum",
    extra => { list => ["xref", "cDNA", "Marker"] },
    is_nullable => 0,
  },
  "analysis_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "external_db_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "identifier",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "unmapped_reason_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "query_score",
  { data_type => "double precision", is_nullable => 1 },
  "target_score",
  { data_type => "double precision", is_nullable => 1 },
  "ensembl_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "ensembl_object_type",
  {
    data_type => "enum",
    default_value => "RawContig",
    extra => { list => ["RawContig", "Transcript", "Gene", "Translation"] },
    is_nullable => 1,
  },
  "parent",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unmapped_object_id>

=back

=cut

__PACKAGE__->set_primary_key("unmapped_object_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<unique_unmapped_obj_idx>

=over 4

=item * L</ensembl_id>

=item * L</ensembl_object_type>

=item * L</identifier>

=item * L</unmapped_reason_id>

=item * L</parent>

=item * L</external_db_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "unique_unmapped_obj_idx",
  [
    "ensembl_id",
    "ensembl_object_type",
    "identifier",
    "unmapped_reason_id",
    "parent",
    "external_db_id",
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

=head2 external_db

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::ExternalDb>

=cut

__PACKAGE__->belongs_to(
  "external_db",
  "Grm::DBIC::Ensembl::Result::ExternalDb",
  { external_db_id => "external_db_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 unmapped_reason

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::UnmappedReason>

=cut

__PACKAGE__->belongs_to(
  "unmapped_reason",
  "Grm::DBIC::Ensembl::Result::UnmappedReason",
  { unmapped_reason_id => "unmapped_reason_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Zl0T/zcWH89tvlu5b+vg3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
