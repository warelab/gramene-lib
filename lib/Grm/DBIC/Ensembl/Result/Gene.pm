package Grm::DBIC::Ensembl::Result::Gene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Gene

=cut

__PACKAGE__->table("gene");

=head1 ACCESSORS

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 biotype

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 display_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 source

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 status

  data_type: 'enum'
  extra: {list => ["KNOWN","NOVEL","PUTATIVE","PREDICTED","KNOWN_BY_PROJECTION","UNKNOWN","ANNOTATED"]}
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 is_current

  data_type: 'enum'
  default_value: 1
  extra: {list => [0,1]}
  is_nullable: 0

=head2 canonical_transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 canonical_annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 version

  data_type: 'smallint'
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
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "biotype",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "display_xref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "source",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "status",
  {
    data_type => "enum",
    extra => {
      list => [
        "KNOWN",
        "NOVEL",
        "PUTATIVE",
        "PREDICTED",
        "KNOWN_BY_PROJECTION",
        "UNKNOWN",
        "ANNOTATED",
      ],
    },
    is_nullable => 1,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "is_current",
  {
    data_type => "enum",
    default_value => 1,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
  "canonical_transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "canonical_annotation",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "version",
  {
    data_type => "smallint",
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
__PACKAGE__->set_primary_key("gene_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wuCjqezvE3xMfYBRxb4e6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
