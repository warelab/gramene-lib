package Grm::DBIC::Protein::Result::DbxrefBk;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::DbxrefBk

=cut

__PACKAGE__->table("dbxref_bk");

=head1 ACCESSORS

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 xref_key

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 xref_keytype

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 xref_dbname

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 xref_desc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "dbxref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "xref_key",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "xref_keytype",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "xref_dbname",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "xref_desc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7WETqmCJoZndY5oYnVnBSQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
