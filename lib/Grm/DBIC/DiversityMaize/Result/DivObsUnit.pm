package Grm::DBIC::DiversityMaize::Result::DivObsUnit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivObsUnit

=cut

__PACKAGE__->table("div_obs_unit");

=head1 ACCESSORS

=head2 div_obs_unit_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_obs_unit_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_experiment_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 div_stock_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 div_locality_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 coord_x

  data_type: 'integer'
  is_nullable: 1

=head2 coord_y

  data_type: 'integer'
  is_nullable: 1

=head2 rep

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 block

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 plot

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 season

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 plant

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 planting_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 harvest_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_obs_unit_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_obs_unit_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_experiment_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_stock_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_locality_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "coord_x",
  { data_type => "integer", is_nullable => 1 },
  "coord_y",
  { data_type => "integer", is_nullable => 1 },
  "rep",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "block",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "plot",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "season",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "plant",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "planting_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "harvest_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_obs_unit_id");
__PACKAGE__->add_unique_constraint("div_obs_unit_acc", ["div_obs_unit_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JFdEp2Mpo1IaWiwNJEWC2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
