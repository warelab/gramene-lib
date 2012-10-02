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

=head2 old_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 old_version

  data_type: 'smallint'
  is_nullable: 1

=head2 new_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 new_version

  data_type: 'smallint'
  is_nullable: 1

=head2 mapping_session_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
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
  "old_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "old_version",
  { data_type => "smallint", is_nullable => 1 },
  "new_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "new_version",
  { data_type => "smallint", is_nullable => 1 },
  "mapping_session_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
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
__PACKAGE__->add_unique_constraint(
  "uni_idx",
  ["mapping_session_id", "old_stable_id", "new_stable_id", "type"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4TwR/2duq0K+8GQe4vOcZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
