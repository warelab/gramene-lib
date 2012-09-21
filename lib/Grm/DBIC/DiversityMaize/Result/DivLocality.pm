package Grm::DBIC::DiversityMaize::Result::DivLocality;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivLocality

=cut

__PACKAGE__->table("div_locality");

=head1 ACCESSORS

=head2 div_locality_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_locality_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 elevation

  data_type: 'integer'
  is_nullable: 1

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 origcty

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 locality_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 state_province

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 lo_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_locality_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_locality_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "elevation",
  { data_type => "integer", is_nullable => 1 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "origcty",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "locality_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "state_province",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "lo_accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_locality_id");
__PACKAGE__->add_unique_constraint("div_locality_acc", ["div_locality_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QiIBIf1+GZQ65DfHMqCybQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
