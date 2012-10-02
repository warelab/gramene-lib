package Grm::DBIC::Ensembl::Result::MappingSession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MappingSession

=cut

__PACKAGE__->table("mapping_session");

=head1 ACCESSORS

=head2 mapping_session_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 old_db_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 80

=head2 new_db_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 80

=head2 old_release

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 5

=head2 new_release

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 5

=head2 old_assembly

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 new_assembly

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "mapping_session_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "old_db_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 80 },
  "new_db_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 80 },
  "old_release",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 5 },
  "new_release",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 5 },
  "old_assembly",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "new_assembly",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("mapping_session_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1iwHzzT3iGrCmOjpPz8VDg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
