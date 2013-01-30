package Grm::DBIC::OntologyTax::Result::GraphPath;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyTax::Result::GraphPath

=cut

__PACKAGE__->table("graph_path");

=head1 ACCESSORS

=head2 graph_path_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term1_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term2_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 distance

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "graph_path_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term1_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term2_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "distance",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("graph_path_id");

=head1 RELATIONS

=head2 term1

Type: belongs_to

Related object: L<Grm::DBIC::OntologyTax::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term1",
  "Grm::DBIC::OntologyTax::Result::Term",
  { term_id => "term1_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 term2

Type: belongs_to

Related object: L<Grm::DBIC::OntologyTax::Result::Term>

=cut

__PACKAGE__->belongs_to(
  "term2",
  "Grm::DBIC::OntologyTax::Result::Term",
  { term_id => "term2_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 graph_path_to_terms

Type: has_many

Related object: L<Grm::DBIC::OntologyTax::Result::GraphPathToTerm>

=cut

__PACKAGE__->has_many(
  "graph_path_to_terms",
  "Grm::DBIC::OntologyTax::Result::GraphPathToTerm",
  { "foreign.graph_path_id" => "self.graph_path_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5YKKaUy+02LDNlGQmnkhuA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
