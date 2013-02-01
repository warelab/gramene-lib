package Grm::DBIC::AmigoGaz::Result::InstanceData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoGaz::Result::InstanceData

=cut

__PACKAGE__->table("instance_data");

=head1 ACCESSORS

=head2 release_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 release_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 release_notes

  data_type: 'text'
  is_nullable: 1

=head2 ontology_data_version

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "release_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "release_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "release_notes",
  { data_type => "text", is_nullable => 1 },
  "ontology_data_version",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->add_unique_constraint("release_name", ["release_name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ACt2HpF2CA4xThbL95CTvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
