package Grm::DBIC::EnsemblCompara::Result::SitewiseAln;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::SitewiseAln

=cut

__PACKAGE__->table("sitewise_aln");

=head1 ACCESSORS

=head2 sitewise_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 aln_position

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 tree_node_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 omega

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 omega_lower

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 omega_upper

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 optimal

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 ncod

  data_type: 'integer'
  is_nullable: 1

=head2 threshold_on_branch_ds

  data_type: 'float'
  is_nullable: 1
  size: [10,5]

=head2 type

  data_type: 'enum'
  extra: {list => ["single_character","random","all_gaps","constant","default","negative1","negative2","negative3","negative4","positive1","positive2","positive3","positive4","synonymous"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sitewise_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "aln_position",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "tree_node_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "omega",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "omega_lower",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "omega_upper",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "optimal",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "ncod",
  { data_type => "integer", is_nullable => 1 },
  "threshold_on_branch_ds",
  { data_type => "float", is_nullable => 1, size => [10, 5] },
  "type",
  {
    data_type => "enum",
    extra => {
      list => [
        "single_character",
        "random",
        "all_gaps",
        "constant",
        "default",
        "negative1",
        "negative2",
        "negative3",
        "negative4",
        "positive1",
        "positive2",
        "positive3",
        "positive4",
        "synonymous",
      ],
    },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("sitewise_id");
__PACKAGE__->add_unique_constraint(
  "aln_position_node_id_ds",
  ["aln_position", "node_id", "threshold_on_branch_ds"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WhLpXNBJyuD0KCUwyLjvsw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
