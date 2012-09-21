package Grm::DBIC::Maps::Result::Mapping;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::Mapping

=cut

__PACKAGE__->table("mapping");

=head1 ACCESSORS

=head2 mapping_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 map_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 display_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 mapping_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 start

  data_type: 'double precision'
  default_value: 0
  is_nullable: 0

=head2 end

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "mapping_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "map_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "display_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "mapping_acc",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "start",
  { data_type => "double precision", default_value => 0, is_nullable => 0 },
  "end",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("mapping_id");
__PACKAGE__->add_unique_constraint("mapping_acc", ["mapping_acc"]);

=head1 RELATIONS

=head2 map

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Map>

=cut

__PACKAGE__->belongs_to(
  "map",
  "Grm::DBIC::Maps::Result::Map",
  { map_id => "map_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 display_synonym

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::FeatureSynonym>

=cut

__PACKAGE__->belongs_to(
  "display_synonym",
  "Grm::DBIC::Maps::Result::FeatureSynonym",
  { feature_synonym_id => "display_synonym_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LvbF+MTNJs2jYc+XRFMnSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
