use utf8;
package Grm::DBIC::Variation::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Source

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<source>

=cut

__PACKAGE__->table("source");

=head1 ACCESSORS

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 24

=head2 version

  data_type: 'integer'
  is_nullable: 1

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 type

  data_type: 'enum'
  extra: {list => ["chip","lsdb"]}
  is_nullable: 1

=head2 somatic_status

  data_type: 'enum'
  default_value: 'germline'
  extra: {list => ["germline","somatic","mixed"]}
  is_nullable: 1

=head2 data_types

  data_type: 'set'
  extra: {list => ["variation","variation_synonym","structural_variation","phenotype_feature","study"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 24 },
  "version",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["chip", "lsdb"] },
    is_nullable => 1,
  },
  "somatic_status",
  {
    data_type => "enum",
    default_value => "germline",
    extra => { list => ["germline", "somatic", "mixed"] },
    is_nullable => 1,
  },
  "data_types",
  {
    data_type => "set",
    extra => {
      list => [
        "variation",
        "variation_synonym",
        "structural_variation",
        "phenotype_feature",
        "study",
      ],
    },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</source_id>

=back

=cut

__PACKAGE__->set_primary_key("source_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i0pDeo3U/NIZIReXd16lVA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
