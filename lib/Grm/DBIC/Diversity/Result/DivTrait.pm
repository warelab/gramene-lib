package Grm::DBIC::Diversity::Result::DivTrait;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::DivTrait

=cut

__PACKAGE__->table("div_trait");

=head1 ACCESSORS

=head2 div_trait_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_trait_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_trait_uom_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_statistic_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_obs_unit_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 value

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 date_measured

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_trait_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_trait_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_trait_uom_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_statistic_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_obs_unit_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "value",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "date_measured",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("div_trait_id");

=head1 RELATIONS

=head2 div_trait_uom

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivTraitUom>

=cut

__PACKAGE__->belongs_to(
  "div_trait_uom",
  "Grm::DBIC::Diversity::Result::DivTraitUom",
  { div_trait_uom_id => "div_trait_uom_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_statistic_type

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivStatisticType>

=cut

__PACKAGE__->belongs_to(
  "div_statistic_type",
  "Grm::DBIC::Diversity::Result::DivStatisticType",
  { div_statistic_type_id => "div_statistic_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_obs_unit

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivObsUnit>

=cut

__PACKAGE__->belongs_to(
  "div_obs_unit",
  "Grm::DBIC::Diversity::Result::DivObsUnit",
  { div_obs_unit_id => "div_obs_unit_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6Evk/vDTt3etTQsytItNew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
