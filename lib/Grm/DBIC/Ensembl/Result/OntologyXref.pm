package Grm::DBIC::Ensembl::Result::OntologyXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::OntologyXref

=cut

__PACKAGE__->table("ontology_xref");

=head1 ACCESSORS

=head2 ontology_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 object_xref_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 source_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 linkage_type

  data_type: 'varchar'
  is_nullable: 1
  size: 3

=cut

__PACKAGE__->add_columns(
  "ontology_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "object_xref_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "source_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "linkage_type",
  { data_type => "varchar", is_nullable => 1, size => 3 },
);
__PACKAGE__->set_primary_key("ontology_xref_id");
__PACKAGE__->add_unique_constraint(
  "object_source_type_idx",
  ["object_xref_id", "source_xref_id", "linkage_type"],
);

=head1 RELATIONS

=head2 object_xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::ObjectXref>

=cut

__PACKAGE__->belongs_to(
  "object_xref",
  "Grm::DBIC::Ensembl::Result::ObjectXref",
  { object_xref_id => "object_xref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 source_xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Xref>

=cut

__PACKAGE__->belongs_to(
  "source_xref",
  "Grm::DBIC::Ensembl::Result::Xref",
  { xref_id => "source_xref_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8CNQ8zI+oiwZAsJkM6shvQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
