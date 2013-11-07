use utf8;
package Grm::DBIC::Ensembl::Result::DataFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::DataFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<data_file>

=cut

__PACKAGE__->table("data_file");

=head1 ACCESSORS

=head2 data_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 coord_system_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 version_lock

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 absolute

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 file_type

  data_type: 'enum'
  extra: {list => ["BAM","BIGBED","BIGWIG","VCF"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "data_file_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "coord_system_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "version_lock",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "absolute",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "file_type",
  {
    data_type => "enum",
    extra => { list => ["BAM", "BIGBED", "BIGWIG", "VCF"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</data_file_id>

=back

=cut

__PACKAGE__->set_primary_key("data_file_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<df_unq_idx>

=over 4

=item * L</coord_system_id>

=item * L</analysis_id>

=item * L</name>

=item * L</file_type>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "df_unq_idx",
  ["coord_system_id", "analysis_id", "name", "file_type"],
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

=head2 coord_system

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::CoordSystem>

=cut

__PACKAGE__->belongs_to(
  "coord_system",
  "Grm::DBIC::Ensembl::Result::CoordSystem",
  { coord_system_id => "coord_system_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Wfr827EZe7XstZCyPbKu5g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
