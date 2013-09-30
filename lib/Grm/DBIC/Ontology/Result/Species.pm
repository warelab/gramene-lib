package Grm::DBIC::Ontology::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 species_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 ncbi_taxa_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 common_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 32

=head2 species

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "species_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ncbi_taxa_id",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "common_name",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 32 },
  "species",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 32 },
);
__PACKAGE__->set_primary_key("species_id");

=head1 RELATIONS

=head2 association_objects

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::AssociationObject>

=cut

__PACKAGE__->has_many(
  "association_objects",
  "Grm::DBIC::Ontology::Result::AssociationObject",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-08-05 15:22:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cr7CvaU7r9B3jjJ2HCzXSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
