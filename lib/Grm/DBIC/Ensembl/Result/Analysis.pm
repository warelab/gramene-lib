package Grm::DBIC::Ensembl::Result::Analysis;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Analysis

=cut

__PACKAGE__->table("analysis");

=head1 ACCESSORS

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 logic_name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 db

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 db_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 db_file

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 program

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 program_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 program_file

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 parameters

  data_type: 'text'
  is_nullable: 1

=head2 module

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 module_version

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 gff_source

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 gff_feature

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "analysis_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "logic_name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "db",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "db_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "db_file",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "program",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "program_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "program_file",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "parameters",
  { data_type => "text", is_nullable => 1 },
  "module",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "module_version",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "gff_source",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "gff_feature",
  { data_type => "varchar", is_nullable => 1, size => 40 },
);
__PACKAGE__->set_primary_key("analysis_id");
__PACKAGE__->add_unique_constraint("logic_name_idx", ["logic_name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Lz+Fz5mka66ld/Lf8BRAjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
