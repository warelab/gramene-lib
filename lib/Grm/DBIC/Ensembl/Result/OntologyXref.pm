use utf8;
package Grm::DBIC::Ensembl::Result::OntologyXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::OntologyXref

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<ontology_xref>

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

=head1 PRIMARY KEY

=over 4

=item * L</ontology_xref_id>

=back

=cut

__PACKAGE__->set_primary_key("ontology_xref_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<object_source_type_idx>

=over 4

=item * L</object_xref_id>

=item * L</source_xref_id>

=item * L</linkage_type>

=back

=cut

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
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
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
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RSeNNpCdNMqJEWmrcGsNug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
