package Grm::DBIC::DiversityArabidopsis::Result::DivStock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::DivStock

=cut

__PACKAGE__->table("div_stock");

=head1 ACCESSORS

=head2 div_stock_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_stock_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_generation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 seed_lot

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 stock_source

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_stock_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_stock_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_generation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_passport_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "seed_lot",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "stock_source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_stock_id");

=head1 RELATIONS

=head2 cdv_markers

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::CdvMarker>

=cut

__PACKAGE__->has_many(
  "cdv_markers",
  "Grm::DBIC::DiversityArabidopsis::Result::CdvMarker",
  { "foreign.div_ref_stock_id" => "self.div_stock_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_obs_units

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivObsUnit>

=cut

__PACKAGE__->has_many(
  "div_obs_units",
  "Grm::DBIC::DiversityArabidopsis::Result::DivObsUnit",
  { "foreign.div_stock_id" => "self.div_stock_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_generation

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivGeneration>

=cut

__PACKAGE__->belongs_to(
  "div_generation",
  "Grm::DBIC::DiversityArabidopsis::Result::DivGeneration",
  { div_generation_id => "div_generation_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_passport

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivPassport>

=cut

__PACKAGE__->belongs_to(
  "div_passport",
  "Grm::DBIC::DiversityArabidopsis::Result::DivPassport",
  { div_passport_id => "div_passport_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_stock_parent_div_stocks

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivStockParent>

=cut

__PACKAGE__->has_many(
  "div_stock_parent_div_stocks",
  "Grm::DBIC::DiversityArabidopsis::Result::DivStockParent",
  { "foreign.div_stock_id" => "self.div_stock_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_stock_parent_div_parents

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivStockParent>

=cut

__PACKAGE__->has_many(
  "div_stock_parent_div_parents",
  "Grm::DBIC::DiversityArabidopsis::Result::DivStockParent",
  { "foreign.div_parent_id" => "self.div_stock_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BtBnipwC6Dags7CqUJaO6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
