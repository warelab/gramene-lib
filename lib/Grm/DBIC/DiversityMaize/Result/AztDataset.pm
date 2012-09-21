package Grm::DBIC::DiversityMaize::Result::AztDataset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AztDataset

=cut

__PACKAGE__->table("azt_dataset");

=head1 ACCESSORS

=head2 azt_dataset_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 dataset_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 dbid

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "azt_dataset_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "dataset_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "dbid",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("azt_dataset_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RmjH/4fN/3fgdfiGtaziZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
