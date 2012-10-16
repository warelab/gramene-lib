package Grm::DBIC::Amigo::Result::Term2termMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::Term2termMetadata

=cut

__PACKAGE__->table("term2term_metadata");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 0

=head2 term1_id

  data_type: 'integer'
  is_nullable: 0

=head2 term2_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "relationship_type_id",
  { data_type => "integer", is_nullable => 0 },
  "term1_id",
  { data_type => "integer", is_nullable => 0 },
  "term2_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("term1_id", ["term1_id", "term2_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J1YtKNaq+XJkUCDSHSPqFw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
