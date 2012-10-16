package Grm::DBIC::Amigo::Result::PhylotreeProperty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::PhylotreeProperty

=cut

__PACKAGE__->table("phylotree_property");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 phylotree_id

  data_type: 'integer'
  is_nullable: 0

=head2 property_key

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 property_val

  data_type: 'mediumtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "phylotree_id",
  { data_type => "integer", is_nullable => 0 },
  "property_key",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "property_val",
  { data_type => "mediumtext", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q5jeMBwGbMh4XZft2SQzHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
