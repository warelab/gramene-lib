package Grm::DBIC::DiversityMaize::Result::DivTraitWinterData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivTraitWinterData

=cut

__PACKAGE__->table("div_trait_winter_data");

=head1 ACCESSORS

=head2 div_obs_unit_div_obs_unit_id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 expr1

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_trait_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_trait_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_trait_uom_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_statistic_type_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_trait_div_obs_unit_id

  data_type: 'integer'
  is_nullable: 1

=head2 value

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 date_measured

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 countofdiv_trait_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_obs_unit_div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "expr1",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_trait_id",
  { data_type => "integer", is_nullable => 1 },
  "div_trait_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_trait_uom_id",
  { data_type => "integer", is_nullable => 1 },
  "div_statistic_type_id",
  { data_type => "integer", is_nullable => 1 },
  "div_trait_div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "value",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "date_measured",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "countofdiv_trait_id",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ChpUi6q+eLjodchIa6uGBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
