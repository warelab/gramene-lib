package Grm::DBIC::AmigoGaz::Result::RelationComposition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoGaz::Result::RelationComposition

=cut

__PACKAGE__->table("relation_composition");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 relation1_id

  data_type: 'integer'
  is_nullable: 0

=head2 relation2_id

  data_type: 'integer'
  is_nullable: 0

=head2 inferred_relation_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "relation1_id",
  { data_type => "integer", is_nullable => 0 },
  "relation2_id",
  { data_type => "integer", is_nullable => 0 },
  "inferred_relation_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "relation1_id",
  ["relation1_id", "relation2_id", "inferred_relation_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QhqJpuIvFnm2zWLvm16mrw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
