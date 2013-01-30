package Grm::DBIC::OntologyPo::Result::GraphPathToTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyPo::Result::GraphPathToTerm

=cut

__PACKAGE__->table("graph_path_to_term");

=head1 ACCESSORS

=head2 graph_path_to_term_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 graph_path_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 rank

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "graph_path_to_term_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "graph_path_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "term_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "rank",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("graph_path_to_term_id");

=head1 RELATIONS

=head2 graph_path

Type: belongs_to

Related object: L<Grm::DBIC::OntologyPo::Result::GraphPath>

=cut

__PACKAGE__->belongs_to(
  "graph_path",
  "Grm::DBIC::OntologyPo::Result::GraphPath",
  { graph_path_id => "graph_path_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LE8ckJKucX2D+rAqYZmblw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
