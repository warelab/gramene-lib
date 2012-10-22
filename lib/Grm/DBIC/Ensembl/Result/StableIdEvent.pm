package Grm::DBIC::Ensembl::Result::StableIdEvent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::StableIdEvent

=cut

__PACKAGE__->table("stable_id_event");

=head1 ACCESSORS

=head2 stable_id_event_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 old_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 old_version

  data_type: 'integer'
  is_nullable: 1

=head2 new_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 new_version

  data_type: 'integer'
  is_nullable: 1

=head2 mapping_session_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["gene","transcript","translation"]}
  is_nullable: 0

=head2 score

  data_type: 'float'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "stable_id_event_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "old_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "old_version",
  { data_type => "integer", is_nullable => 1 },
  "new_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "new_version",
  { data_type => "integer", is_nullable => 1 },
  "mapping_session_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "type",
  {
    data_type => "enum",
    extra => { list => ["gene", "transcript", "translation"] },
    is_nullable => 0,
  },
  "score",
  { data_type => "float", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("stable_id_event_id");
__PACKAGE__->add_unique_constraint(
  "uni_idx",
  ["mapping_session_id", "old_stable_id", "new_stable_id", "type"],
);

=head1 RELATIONS

=head2 mapping_session

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MappingSession>

=cut

__PACKAGE__->belongs_to(
  "mapping_session",
  "Grm::DBIC::Ensembl::Result::MappingSession",
  { mapping_session_id => "mapping_session_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Zpsi1wIrbPpw/kYRYc8CZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
