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

=head2 object_xref_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 source_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 linkage_type

  data_type: 'varchar'
  is_nullable: 1
  size: 3

=cut

__PACKAGE__->add_columns(
  "object_xref_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "source_xref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "linkage_type",
  { data_type => "varchar", is_nullable => 1, size => 3 },
);
__PACKAGE__->add_unique_constraint(
  "object_source_type_idx",
  ["object_xref_id", "source_xref_id", "linkage_type"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XE4uXuWMWfk3BwLCGlhYwA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
