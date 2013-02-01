package Grm::DBIC::AmigoPo::Result::Dbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoPo::Result::Dbxref

=cut

__PACKAGE__->table("dbxref");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 xref_dbname

  data_type: 'varchar'
  is_nullable: 0
  size: 55

=head2 xref_key

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 xref_keytype

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 xref_desc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "xref_dbname",
  { data_type => "varchar", is_nullable => 0, size => 55 },
  "xref_key",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "xref_keytype",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "xref_desc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("dx6", ["xref_key", "xref_dbname"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4aMhie26SqW3FL5umRUCTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
