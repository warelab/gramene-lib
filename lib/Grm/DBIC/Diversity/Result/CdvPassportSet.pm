package Grm::DBIC::Diversity::Result::CdvPassportSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvPassportSet

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
  is_foreign_key: 1
  is_nullable: 1

=head2 cdv_passport_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "cdv_passport_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("cdv_passport_set_id");

=head1 RELATIONS

=head2 div_passport

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::DivPassport>

=cut

__PACKAGE__->belongs_to(
  "div_passport",
  "Grm::DBIC::Diversity::Result::DivPassport",
  { div_passport_id => "div_passport_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cdv_passport_group

Type: belongs_to

Related object: L<Grm::DBIC::Diversity::Result::CdvPassportGroup>

=cut

__PACKAGE__->belongs_to(
  "cdv_passport_group",
  "Grm::DBIC::Diversity::Result::CdvPassportGroup",
  { cdv_passport_group_id => "cdv_passport_group_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E9gDQf+kQtRhMbtSfcC90g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
