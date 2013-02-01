package Grm::DBIC::AmigoPo::Result::SourceAudit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoPo::Result::SourceAudit

=cut

__PACKAGE__->table("source_audit");

=head1 ACCESSORS

=head2 source_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_fullpath

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_md5

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 source_parsetime

  data_type: 'integer'
  is_nullable: 1

=head2 source_mtime

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_fullpath",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_md5",
  { data_type => "char", is_nullable => 1, size => 32 },
  "source_parsetime",
  { data_type => "integer", is_nullable => 1 },
  "source_mtime",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aniyqkoIFZxCM09r9vjwsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
