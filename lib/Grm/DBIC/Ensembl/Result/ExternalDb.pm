package Grm::DBIC::Ensembl::Result::ExternalDb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ExternalDb

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
__PACKAGE__->set_primary_key("external_db_id");
__PACKAGE__->add_unique_constraint("db_name_db_release_idx", ["db_name", "db_release"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AK+MUElpVdCukw8pIc1LMA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
