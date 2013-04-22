package Grm::DBIC::Qtl::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 species_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 species

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 common_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 gramene_taxonomy_id

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 ncbi_taxonomy_id

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 display_order

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "species_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "species",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "gramene_taxonomy_id",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "ncbi_taxonomy_id",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "display_order",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("species_id");
__PACKAGE__->add_unique_constraint("species", ["species"]);

=head1 RELATIONS

=head2 qtls

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::Qtl>

=cut

__PACKAGE__->has_many(
  "qtls",
  "Grm::DBIC::Qtl::Result::Qtl",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F/dydTYEqWDlQIBl2aHLGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
