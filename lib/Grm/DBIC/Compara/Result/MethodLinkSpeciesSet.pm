package Grm::DBIC::Compara::Result::MethodLinkSpeciesSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::MethodLinkSpeciesSet

=cut

__PACKAGE__->table("method_link_species_set");

=head1 ACCESSORS

=head2 method_link_species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 method_link_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 species_set_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 source

  data_type: 'varchar'
  default_value: 'ensembl'
  is_nullable: 0
  size: 255

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "method_link_species_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "method_link_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "species_set_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "source",
  {
    data_type => "varchar",
    default_value => "ensembl",
    is_nullable => 0,
    size => 255,
  },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("method_link_species_set_id");
__PACKAGE__->add_unique_constraint("method_link_id", ["method_link_id", "species_set_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yYxox0iIo2ugxwpyKBCwKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
