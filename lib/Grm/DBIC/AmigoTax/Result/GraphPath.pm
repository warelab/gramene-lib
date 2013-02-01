package Grm::DBIC::AmigoTax::Result::GraphPath;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTax::Result::GraphPath

=cut

__PACKAGE__->table("graph_path");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term1_id

  data_type: 'integer'
  is_nullable: 0

=head2 term2_id

  data_type: 'integer'
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 1

=head2 distance

  data_type: 'integer'
  is_nullable: 1

=head2 relation_distance

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term1_id",
  { data_type => "integer", is_nullable => 0 },
  "term2_id",
  { data_type => "integer", is_nullable => 0 },
  "relationship_type_id",
  { data_type => "integer", is_nullable => 1 },
  "distance",
  { data_type => "integer", is_nullable => 1 },
  "relation_distance",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e1uQ/TDcdh+cnKdxsDn44Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
