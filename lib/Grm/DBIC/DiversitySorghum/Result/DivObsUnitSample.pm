package Grm::DBIC::DiversitySorghum::Result::DivObsUnitSample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivObsUnitSample

=cut

__PACKAGE__->table("div_obs_unit_sample");

=head1 ACCESSORS

=head2 div_obs_unit_sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_obs_unit_sample_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_obs_unit_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 producer

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_obs_unit_sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_obs_unit_sample_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_obs_unit_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "producer",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_obs_unit_sample_id");

=head1 RELATIONS

=head2 div_alleles

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivAllele>

=cut

__PACKAGE__->has_many(
  "div_alleles",
  "Grm::DBIC::DiversitySorghum::Result::DivAllele",
  {
    "foreign.div_obs_unit_sample_id" => "self.div_obs_unit_sample_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_obs_unit

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivObsUnit>

=cut

__PACKAGE__->belongs_to(
  "div_obs_unit",
  "Grm::DBIC::DiversitySorghum::Result::DivObsUnit",
  { div_obs_unit_id => "div_obs_unit_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A8TExBTD1uMjwrxn1UNFZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
