package Grm::DBIC::Ontology::Result::AssociationObjectType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::AssociationObjectType

=cut

__PACKAGE__->table("association_object_type");

=head1 ACCESSORS

=head2 association_object_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "association_object_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("association_object_type_id");
__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 association_objects

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::AssociationObject>

=cut

__PACKAGE__->has_many(
  "association_objects",
  "Grm::DBIC::Ontology::Result::AssociationObject",
  {
    "foreign.association_object_type_id" => "self.association_object_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-08-05 15:22:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rbK+2OVlTQfVCVW9yx25sw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
