use utf8;
package Grm::DBIC::Ontology::Result::AssociationObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::AssociationObject

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<association_object>

=cut

__PACKAGE__->table("association_object");

=head1 ACCESSORS

=head2 association_object_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 association_object_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 db_object_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 db_object_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 db_object_symbol

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 species_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "association_object_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "association_object_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "db_object_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "db_object_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "db_object_symbol",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "species_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</association_object_id>

=back

=cut

__PACKAGE__->set_primary_key("association_object_id");

=head1 RELATIONS

=head2 association_object_type

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::AssociationObjectType>

=cut

__PACKAGE__->belongs_to(
  "association_object_type",
  "Grm::DBIC::Ontology::Result::AssociationObjectType",
  { association_object_type_id => "association_object_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 associations

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::Association>

=cut

__PACKAGE__->has_many(
  "associations",
  "Grm::DBIC::Ontology::Result::Association",
  { "foreign.association_object_id" => "self.association_object_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Ontology::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bGwJz6smrGLTnIlkHTXIdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
