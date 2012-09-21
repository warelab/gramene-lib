package Grm::DBIC::DiversitySorghum::Result::DivSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivSynonym

=cut

__PACKAGE__->table("div_synonym");

=head1 ACCESSORS

=head2 div_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_synonym_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 synonym

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_synonym_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_passport_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "synonym",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_synonym_id");

=head1 RELATIONS

=head2 div_passport

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivPassport>

=cut

__PACKAGE__->belongs_to(
  "div_passport",
  "Grm::DBIC::DiversitySorghum::Result::DivPassport",
  { div_passport_id => "div_passport_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6Imu3pMvbjw1BI26C4zn0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
