package Grm::DBIC::Ensembl::Result::UnmappedObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::UnmappedObject

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
  is_nullable: 0

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 unmapped_reason_id

  data_type: 'smallint'
  extra: {unsigned => 1}
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
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "external_db_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "identifier",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "unmapped_reason_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
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
__PACKAGE__->set_primary_key("unmapped_object_id");
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wQFPKMMWaYF6s42gmIOOnQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
