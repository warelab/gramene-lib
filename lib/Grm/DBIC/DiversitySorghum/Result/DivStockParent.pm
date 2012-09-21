package Grm::DBIC::DiversitySorghum::Result::DivStockParent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivStockParent

=cut

__PACKAGE__->table("div_stock_parent");

=head1 ACCESSORS

=head2 div_stock_parent_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_stock_parent_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_stock_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_parent_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 role

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 recurrent

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_stock_parent_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_stock_parent_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_stock_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_parent_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "role",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "recurrent",
  { data_type => "tinyint", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_stock_parent_id");

=head1 RELATIONS

=head2 div_stock

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivStock>

=cut

__PACKAGE__->belongs_to(
  "div_stock",
  "Grm::DBIC::DiversitySorghum::Result::DivStock",
  { div_stock_id => "div_stock_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_parent

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivStock>

=cut

__PACKAGE__->belongs_to(
  "div_parent",
  "Grm::DBIC::DiversitySorghum::Result::DivStock",
  { div_stock_id => "div_parent_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1bXhl1PFYFgswYiFumh6tQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
