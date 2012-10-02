package Grm::DBIC::Ensembl::Result::ObjectXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ObjectXref

=cut

__PACKAGE__->table("object_xref");

=head1 ACCESSORS

=head2 object_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ensembl_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 ensembl_object_type

  data_type: 'enum'
  extra: {list => ["RawContig","Transcript","Gene","Translation","Operon","OperonTranscript"]}
  is_nullable: 0

=head2 xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 linkage_annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "object_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ensembl_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "ensembl_object_type",
  {
    data_type => "enum",
    extra => {
      list => [
        "RawContig",
        "Transcript",
        "Gene",
        "Translation",
        "Operon",
        "OperonTranscript",
      ],
    },
    is_nullable => 0,
  },
  "xref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "linkage_annotation",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("object_xref_id");
__PACKAGE__->add_unique_constraint(
  "xref_idx",
  ["xref_id", "ensembl_object_type", "ensembl_id", "analysis_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WtBXLqC6AW9wTi4oJFd/HA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
