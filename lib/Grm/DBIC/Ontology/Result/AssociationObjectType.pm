use utf8;
package Grm::DBIC::Ontology::Result::AssociationObjectType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::AssociationObjectType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<association_object_type>

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

=head1 PRIMARY KEY

=over 4

=item * L</association_object_type_id>

=back

=cut

__PACKAGE__->set_primary_key("association_object_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vnXwRSqrSbKjRedSeVqfvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
