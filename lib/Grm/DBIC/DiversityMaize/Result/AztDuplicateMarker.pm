package Grm::DBIC::DiversityMaize::Result::AztDuplicateMarker;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AztDuplicateMarker

=cut

__PACKAGE__->table("azt_duplicate_marker");

=head1 ACCESSORS

=head2 dup_cluster_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cdv_marker_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "dup_cluster_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cdv_marker_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2zs46kd7nvV6HnAHjXTPHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
