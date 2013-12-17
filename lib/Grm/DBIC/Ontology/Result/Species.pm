use utf8;
package Grm::DBIC::Ontology::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::Species

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<species>

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
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "species_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ncbi_taxa_id",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</species_id>

=back

=cut

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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZoHBdKHokhwQgtIkncANfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
