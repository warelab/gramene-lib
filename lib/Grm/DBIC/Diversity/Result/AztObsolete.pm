package Grm::DBIC::Diversity::Result::AztObsolete;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AztObsolete

=cut

__PACKAGE__->table("azt_obsolete");

=head1 ACCESSORS

=head2 azt_obsolete

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 primary_name

  data_type: 'varchar'
  default_value: 0
  is_nullable: 0
  size: 50

=head2 change_to

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 date_modified

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 comments

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "azt_obsolete",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "table_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "primary_name",
  { data_type => "varchar", default_value => 0, is_nullable => 0, size => 50 },
  "change_to",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "date_modified",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "comments",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("azt_obsolete");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BKCN3H+rzkgAGHb6fBAbzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
