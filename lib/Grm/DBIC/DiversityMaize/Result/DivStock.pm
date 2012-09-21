package Grm::DBIC::DiversityMaize::Result::DivStock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivStock

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
  is_nullable: 1

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
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
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_passport_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "seed_lot",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "stock_source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_stock_id");
__PACKAGE__->add_unique_constraint("div_stock_acc", ["div_stock_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cKcMCX9B/E81TslS1kS5Fw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
