package Grm::DBIC::Ensembl::Result::Xref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Xref

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
  extra: {list => ["PROJECTION","MISC","DEPENDENT","DIRECT","SEQUENCE_MATCH","INFERRED_PAIR","PROBE","UNMAPPED","COORDINATE_OVERLAP","CHECKSUM"]}
  is_nullable: 1

=head2 info_text

  data_type: 'varchar'
  is_nullable: 1
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
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
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
    extra => {
      list => [
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
    is_nullable => 1,
  },
  "info_text",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("xref_id");
__PACKAGE__->add_unique_constraint(
  "id_index",
  ["dbprimary_acc", "external_db_id", "info_type", "info_text"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A4j/nxD5yaXxpIG91LDcKA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
