package Grm::DBIC::DiversityMaize::Result::AuxUomToPassport;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxUomToPassport

=cut

__PACKAGE__->table("aux_uom_to_passport");

=head1 ACCESSORS

=head2 aux_uom_to_passport_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 div_trait_uom_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_trait_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_obs_unit_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_locality_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_stock_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_passport_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_uom_to_passport_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "div_trait_uom_id",
  { data_type => "integer", is_nullable => 1 },
  "div_trait_id",
  { data_type => "integer", is_nullable => 1 },
  "div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "div_locality_id",
  { data_type => "integer", is_nullable => 1 },
  "div_stock_id",
  { data_type => "integer", is_nullable => 1 },
  "div_passport_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_uom_to_passport_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dG9PKIO0OHde7gqIS8g5Ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
