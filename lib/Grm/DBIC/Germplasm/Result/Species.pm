package Grm::DBIC::Germplasm::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Germplasm::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 species_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 gramene_taxonomy_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=cut

__PACKAGE__->add_columns(
  "species_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "gramene_taxonomy_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("species_id");
__PACKAGE__->add_unique_constraint("name", ["name"]);
__PACKAGE__->add_unique_constraint("gramene_taxonomy_id", ["gramene_taxonomy_id"]);

=head1 RELATIONS

=head2 germplasms

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::Germplasm>

=cut

__PACKAGE__->has_many(
  "germplasms",
  "Grm::DBIC::Germplasm::Result::Germplasm",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:02:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:loii74D0uaUUTZhAGy1QKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
