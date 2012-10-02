package Grm::DBIC::Help::Result::Topic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Help::Result::Topic

=cut

__PACKAGE__->table("topic");

=head1 ACCESSORS

=head2 topic_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 topic_parent_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 is_open

  data_type: 'tinyint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 number

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 reverse_order

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 publishdate

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 link_name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 url_override

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 created_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 last_modified

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "topic_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "topic_parent_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "is_open",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "number",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "reverse_order",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "publishdate",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "link_name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "url_override",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "created_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "last_modified",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("topic_id");
__PACKAGE__->add_unique_constraint("pair", ["name", "topic_parent_id"]);

=head1 RELATIONS

=head2 questions

Type: has_many

Related object: L<Grm::DBIC::Help::Result::Question>

=cut

__PACKAGE__->has_many(
  "questions",
  "Grm::DBIC::Help::Result::Question",
  { "foreign.topic_id" => "self.topic_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topic_parent

Type: belongs_to

Related object: L<Grm::DBIC::Help::Result::Topic>

=cut

__PACKAGE__->belongs_to(
  "topic_parent",
  "Grm::DBIC::Help::Result::Topic",
  { topic_id => "topic_parent_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 topics

Type: has_many

Related object: L<Grm::DBIC::Help::Result::Topic>

=cut

__PACKAGE__->has_many(
  "topics",
  "Grm::DBIC::Help::Result::Topic",
  { "foreign.topic_parent_id" => "self.topic_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TAS59Qx3GI/LvFTLbCaR9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
