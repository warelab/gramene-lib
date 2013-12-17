use utf8;
package Grm::DBIC::Ontology::Result::Association;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::Association

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<association>

=cut

__PACKAGE__->table("association");

=head1 ACCESSORS

=head2 association_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 association_object_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 evidence_code

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "association_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "association_object_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "evidence_code",
  { data_type => "char", default_value => "", is_nullable => 1, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</association_id>

=back

=cut

__PACKAGE__->set_primary_key("association_id");

=head1 RELATIONS

=head2 association_object

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::AssociationObject>

=cut

__PACKAGE__->belongs_to(
  "association_object",
  "Grm::DBIC::Ontology::Result::AssociationObject",
  { association_object_id => "association_object_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::Ontology::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rpPtCHO/R5IfFvBLcvcaSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
