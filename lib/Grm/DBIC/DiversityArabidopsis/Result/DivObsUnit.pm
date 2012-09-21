package Grm::DBIC::DiversityArabidopsis::Result::DivObsUnit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::DivObsUnit

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
  is_foreign_key: 1
  is_nullable: 1

=head2 div_stock_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_locality_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_stock_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_locality_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
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

=head1 RELATIONS

=head2 div_experiment

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivExperiment>

=cut

__PACKAGE__->belongs_to(
  "div_experiment",
  "Grm::DBIC::DiversityArabidopsis::Result::DivExperiment",
  { div_experiment_id => "div_experiment_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_stock

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivStock>

=cut

__PACKAGE__->belongs_to(
  "div_stock",
  "Grm::DBIC::DiversityArabidopsis::Result::DivStock",
  { div_stock_id => "div_stock_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_locality

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivLocality>

=cut

__PACKAGE__->belongs_to(
  "div_locality",
  "Grm::DBIC::DiversityArabidopsis::Result::DivLocality",
  { div_locality_id => "div_locality_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_obs_unit_samples

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivObsUnitSample>

=cut

__PACKAGE__->has_many(
  "div_obs_unit_samples",
  "Grm::DBIC::DiversityArabidopsis::Result::DivObsUnitSample",
  { "foreign.div_obs_unit_id" => "self.div_obs_unit_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_traits

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivTrait>

=cut

__PACKAGE__->has_many(
  "div_traits",
  "Grm::DBIC::DiversityArabidopsis::Result::DivTrait",
  { "foreign.div_obs_unit_id" => "self.div_obs_unit_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:v9XKjfrLOwZIFZI4otZ0bA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
