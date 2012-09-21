package Grm::DBIC::DiversityMaize::Result::CdvCuration;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::CdvCuration

=cut

__PACKAGE__->table("cdv_curation");

=head1 ACCESSORS

=head2 cdv_curation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_curation_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_reason_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 curator

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 curation_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_curation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_curation_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_reason_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "curator",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "curation_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_curation_id");
__PACKAGE__->add_unique_constraint("cdv_curation_acc", ["cdv_curation_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FNmLrAy83qjA66qkAPtHMw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
