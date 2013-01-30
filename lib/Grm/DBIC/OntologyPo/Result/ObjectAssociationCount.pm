package Grm::DBIC::OntologyPo::Result::ObjectAssociationCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyPo::Result::ObjectAssociationCount

=cut

__PACKAGE__->table("object_association_count");

=head1 ACCESSORS

=head2 object_association_count_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 object_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 object_species

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 object_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 association_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "object_association_count_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "object_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "object_species",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "object_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "association_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("object_association_count_id");
__PACKAGE__->add_unique_constraint("term_id", ["term_id", "object_type", "object_species"]);

=head1 RELATIONS

=head2 term

Type: belongs_to

Related object: L<Grm::DBIC::OntologyPo::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term",
  "Grm::DBIC::OntologyPo::Result::Term",
  { term_id => "term_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FezXcHEMXgqHhF1d9gJ9qg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
