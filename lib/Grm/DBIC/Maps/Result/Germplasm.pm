package Grm::DBIC::Maps::Result::Germplasm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::Germplasm

=cut

__PACKAGE__->table("germplasm");

=head1 ACCESSORS

=head2 germplasm_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 germplasm_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 germplasm_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 species_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "germplasm_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "germplasm_acc",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "germplasm_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "species_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("germplasm_id");
__PACKAGE__->add_unique_constraint("germplasm_acc", ["germplasm_acc"]);
__PACKAGE__->add_unique_constraint("species_id", ["species_id", "germplasm_name"]);

=head1 RELATIONS

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Maps::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 germplasms_to_map_set

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::GermplasmToMapSet>

=cut

__PACKAGE__->has_many(
  "germplasms_to_map_set",
  "Grm::DBIC::Maps::Result::GermplasmToMapSet",
  { "foreign.germplasm_id" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-11-14 16:11:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hv/FSmaCoB5Sg5F32cmX9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
