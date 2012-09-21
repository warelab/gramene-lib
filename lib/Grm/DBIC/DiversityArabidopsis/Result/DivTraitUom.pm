package Grm::DBIC::DiversityArabidopsis::Result::DivTraitUom;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::DivTraitUom

=cut

__PACKAGE__->table("div_trait_uom");

=head1 ACCESSORS

=head2 div_trait_uom_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_trait_uom_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_unit_of_measure_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 local_trait_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 trait_protocol

  data_type: 'text'
  is_nullable: 1

=head2 to_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 eo_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_trait_uom_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_trait_uom_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_unit_of_measure_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "local_trait_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "trait_protocol",
  { data_type => "text", is_nullable => 1 },
  "to_accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "eo_accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_trait_uom_id");
__PACKAGE__->add_unique_constraint("local_trait_name", ["local_trait_name"]);

=head1 RELATIONS

=head2 div_traits

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivTrait>

=cut

__PACKAGE__->has_many(
  "div_traits",
  "Grm::DBIC::DiversityArabidopsis::Result::DivTrait",
  { "foreign.div_trait_uom_id" => "self.div_trait_uom_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_unit_of_measure

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivUnitOfMeasure>

=cut

__PACKAGE__->belongs_to(
  "div_unit_of_measure",
  "Grm::DBIC::DiversityArabidopsis::Result::DivUnitOfMeasure",
  { div_unit_of_measure_id => "div_unit_of_measure_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZgX0eE34ZVUnextQBDUi0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
