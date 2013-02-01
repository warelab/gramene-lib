package Grm::DBIC::AmigoTo::Result::AssociationProperty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTo::Result::AssociationProperty

=cut

__PACKAGE__->table("association_property");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 association_id

  data_type: 'integer'
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "association_id",
  { data_type => "integer", is_nullable => 0 },
  "relationship_type_id",
  { data_type => "integer", is_nullable => 0 },
  "term_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X1btYZIEM4fzVFlxdNo1WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
