package Grm::DBIC::DiversitySorghum::Result::DivUnitOfMeasure;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivUnitOfMeasure

=cut

__PACKAGE__->table("div_unit_of_measure");

=head1 ACCESSORS

=head2 div_unit_of_measure_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_unit_of_measure_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 unit_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_unit_of_measure_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_unit_of_measure_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "unit_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_unit_of_measure_id");

=head1 RELATIONS

=head2 div_trait_uoms

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivTraitUom>

=cut

__PACKAGE__->has_many(
  "div_trait_uoms",
  "Grm::DBIC::DiversitySorghum::Result::DivTraitUom",
  {
    "foreign.div_unit_of_measure_id" => "self.div_unit_of_measure_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2SW73VfPYofzaSKdayoCNw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
