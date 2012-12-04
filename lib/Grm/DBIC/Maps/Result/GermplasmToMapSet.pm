package Grm::DBIC::Maps::Result::GermplasmToMapSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::GermplasmToMapSet

=cut

__PACKAGE__->table("germplasm_to_map_set");

=head1 ACCESSORS

=head2 germplasm_to_map_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 germplasm_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 map_set_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 relationship

  data_type: 'enum'
  extra: {list => ["Unknown","Donor Parent","Female Parent","Male Parent","Parental Germplasm","Recurrent Parent"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "germplasm_to_map_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "germplasm_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "map_set_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "relationship",
  {
    data_type => "enum",
    extra => {
      list => [
        "Unknown",
        "Donor Parent",
        "Female Parent",
        "Male Parent",
        "Parental Germplasm",
        "Recurrent Parent",
      ],
    },
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("germplasm_to_map_set_id");
__PACKAGE__->add_unique_constraint(
  "germplasm_id",
  ["germplasm_id", "map_set_id", "relationship"],
);

=head1 RELATIONS

=head2 germplasm

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Germplasm>

=cut

__PACKAGE__->belongs_to(
  "germplasm",
  "Grm::DBIC::Maps::Result::Germplasm",
  { germplasm_id => "germplasm_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 map_set

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::MapSet>

=cut

__PACKAGE__->belongs_to(
  "map_set",
  "Grm::DBIC::Maps::Result::MapSet",
  { map_set_id => "map_set_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-11-14 16:11:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xfzqUUHeNYCrDiEel4HBug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
