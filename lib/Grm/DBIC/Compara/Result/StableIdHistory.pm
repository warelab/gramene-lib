package Grm::DBIC::Compara::Result::StableIdHistory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::StableIdHistory

=cut

__PACKAGE__->table("stable_id_history");

=head1 ACCESSORS

=head2 mapping_session_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 stable_id_from

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 40

=head2 version_from

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 stable_id_to

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 40

=head2 version_to

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 contribution

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "mapping_session_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "stable_id_from",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 40 },
  "version_from",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "stable_id_to",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 40 },
  "version_to",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "contribution",
  { data_type => "float", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("mapping_session_id", "stable_id_from", "stable_id_to");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NNtZJMnrNlpSteVlldzD/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
