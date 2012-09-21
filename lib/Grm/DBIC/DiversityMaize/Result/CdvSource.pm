package Grm::DBIC::DiversityMaize::Result::CdvSource;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::CdvSource

=cut

__PACKAGE__->table("cdv_source");

=head1 ACCESSORS

=head2 cdv_source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_source_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 contact

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 institute

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 department

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 address

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 state_province

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 phone

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 fax

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_source_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_source_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "contact",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "institute",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "department",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "address",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "state_province",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "phone",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "fax",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_source_id");
__PACKAGE__->add_unique_constraint("cdv_source_acc", ["cdv_source_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PjFBHdJ36etuTa5fqC/RtQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
