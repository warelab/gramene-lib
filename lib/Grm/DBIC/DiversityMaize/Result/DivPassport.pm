package Grm::DBIC::DiversityMaize::Result::DivPassport;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivPassport

=cut

__PACKAGE__->table("div_passport");

=head1 ACCESSORS

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_passport_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_taxonomy_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 div_accession_collecting_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cdv_source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 accename

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 accenumb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sampstat

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_passport_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_passport_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_taxonomy_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "div_accession_collecting_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cdv_source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "accename",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "accenumb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sampstat",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_passport_id");
__PACKAGE__->add_unique_constraint("accename_source", ["accename", "source"]);
__PACKAGE__->add_unique_constraint("div_passport_acc", ["div_passport_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CFweKzehAqEgvg8zmCCahw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
