package Grm::DBIC::DiversityWheat::Result::CdvPassportGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::CdvPassportGroup

=cut

__PACKAGE__->table("cdv_passport_group");

=head1 ACCESSORS

=head2 cdv_passport_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_passport_group_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 group_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_passport_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_passport_group_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "group_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_passport_group_id");

=head1 RELATIONS

=head2 cdv_passport_sets

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::CdvPassportSet>

=cut

__PACKAGE__->has_many(
  "cdv_passport_sets",
  "Grm::DBIC::DiversityWheat::Result::CdvPassportSet",
  { "foreign.cdv_passport_group_id" => "self.cdv_passport_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:97rmUGockIL37F+vGLF2Dw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
