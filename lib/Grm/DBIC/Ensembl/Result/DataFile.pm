package Grm::DBIC::Ensembl::Result::DataFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::DataFile

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
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
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
  { data_type => "integer", is_nullable => 0 },
  "analysis_id",
  { data_type => "integer", is_nullable => 0 },
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
__PACKAGE__->set_primary_key("data_file_id");
__PACKAGE__->add_unique_constraint(
  "df_unq_idx",
  ["coord_system_id", "analysis_id", "name", "file_type"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MzS5+3VQ2oKiMT9mQAG3xQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
