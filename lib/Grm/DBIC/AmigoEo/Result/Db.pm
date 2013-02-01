package Grm::DBIC::AmigoEo::Result::Db;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoEo::Result::Db

=cut

__PACKAGE__->table("db");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 55

=head2 fullname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 datatype

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 generic_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url_syntax

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url_example

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 uri_prefix

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 55 },
  "fullname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "datatype",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "generic_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url_syntax",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url_example",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "uri_prefix",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name", ["name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nRahQ2c4mH9PcXMRHnpMHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
