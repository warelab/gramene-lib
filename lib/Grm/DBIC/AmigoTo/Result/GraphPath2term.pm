package Grm::DBIC::AmigoTo::Result::GraphPath2term;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTo::Result::GraphPath2term

=cut

__PACKAGE__->table("graph_path2term");

=head1 ACCESSORS

=head2 graph_path_id

  data_type: 'integer'
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 rank

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "graph_path_id",
  { data_type => "integer", is_nullable => 0 },
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "rank",
  { data_type => "integer", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7ps1x36uwFHH4i2tHEPvbQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
