package Grm::DBIC::DiversityMaize::Result::CdvPassportSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::CdvPassportSet

=cut

__PACKAGE__->table("cdv_passport_set");

=head1 ACCESSORS

=head2 cdv_passport_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_passport_set_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cdv_passport_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_passport_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_passport_set_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_passport_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cdv_passport_group_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_passport_set_id");
__PACKAGE__->add_unique_constraint("cdv_passport_set_acc", ["cdv_passport_set_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7qINP9935vl+cKVp+1FgUQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
