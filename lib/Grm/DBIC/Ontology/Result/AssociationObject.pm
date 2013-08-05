package Grm::DBIC::Ontology::Result::AssociationObject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::AssociationObject

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

=head2 synonyms

  data_type: 'text'
  is_nullable: 1

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
  "synonyms",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("association_object_id");

=head1 RELATIONS

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

=head2 association_object_type

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::AssociationObjectType>

=cut

__PACKAGE__->belongs_to(
  "association_object_type",
  "Grm::DBIC::Ontology::Result::AssociationObjectType",
  { association_object_type_id => "association_object_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Ontology::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-08-05 15:13:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y1XPy4jcAIjnzYCoOJ6Ulg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
