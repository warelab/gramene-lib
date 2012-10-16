package Grm::DBIC::Amigo::Result::RelationProperty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::RelationProperty

=cut

__PACKAGE__->table("relation_properties");

=head1 ACCESSORS

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 0

=head2 is_transitive

  data_type: 'integer'
  is_nullable: 1

=head2 is_symmetric

  data_type: 'integer'
  is_nullable: 1

=head2 is_anti_symmetric

  data_type: 'integer'
  is_nullable: 1

=head2 is_cyclic

  data_type: 'integer'
  is_nullable: 1

=head2 is_reflexive

  data_type: 'integer'
  is_nullable: 1

=head2 is_metadata_tag

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "relationship_type_id",
  { data_type => "integer", is_nullable => 0 },
  "is_transitive",
  { data_type => "integer", is_nullable => 1 },
  "is_symmetric",
  { data_type => "integer", is_nullable => 1 },
  "is_anti_symmetric",
  { data_type => "integer", is_nullable => 1 },
  "is_cyclic",
  { data_type => "integer", is_nullable => 1 },
  "is_reflexive",
  { data_type => "integer", is_nullable => 1 },
  "is_metadata_tag",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("rp1", ["relationship_type_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zzSjVpiiWzpHf85+kVYJHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
