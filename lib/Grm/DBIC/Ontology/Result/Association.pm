package Grm::DBIC::Ontology::Result::Association;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::Association

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
__PACKAGE__->set_primary_key("association_id");

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::Ontology::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 association_object

Type: belongs_to

Related object: L<Grm::DBIC::Ontology::Result::AssociationObject>

=cut

__PACKAGE__->belongs_to(
  "association_object",
  "Grm::DBIC::Ontology::Result::AssociationObject",
  { association_object_id => "association_object_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-24 18:25:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FdMwHcNkizYp/yewiMcOEg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
