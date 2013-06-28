package Grm::DBIC::Protein::Result::ObjectxrefBk;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::ObjectxrefBk

=cut

__PACKAGE__->table("objectxref_bk");

=head1 ACCESSORS

=head2 objectxref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 60

=head2 row_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "objectxref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "table_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 60 },
  "row_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dbxref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bDWysdDnCKv23Es3jC3pVA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
