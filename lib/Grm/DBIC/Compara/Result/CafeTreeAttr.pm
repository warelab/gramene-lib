package Grm::DBIC::Compara::Result::CafeTreeAttr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::CafeTreeAttr

=cut

__PACKAGE__->table("CAFE_tree_attr");

=head1 ACCESSORS

=head2 node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 fam_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 taxon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 n_members

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 p_value

  data_type: 'double precision'
  is_nullable: 1
  size: [5,4]

=head2 avg_pvalue

  data_type: 'double precision'
  is_nullable: 1
  size: [5,4]

=cut

__PACKAGE__->add_columns(
  "node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "fam_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "taxon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "n_members",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "p_value",
  { data_type => "double precision", is_nullable => 1, size => [5, 4] },
  "avg_pvalue",
  { data_type => "double precision", is_nullable => 1, size => [5, 4] },
);
__PACKAGE__->add_unique_constraint("node_id", ["node_id", "fam_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OiQOLeTlzZQ5GgW8//QhpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
