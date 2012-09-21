package Grm::DBIC::DiversityArabidopsis::Result::CdvReason;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::CdvReason

=cut

__PACKAGE__->table("cdv_reason");

=head1 ACCESSORS

=head2 cdv_reason_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_reason_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_reason_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_reason_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_reason_id");

=head1 RELATIONS

=head2 cdv_curations

Type: has_many

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::CdvCuration>

=cut

__PACKAGE__->has_many(
  "cdv_curations",
  "Grm::DBIC::DiversityArabidopsis::Result::CdvCuration",
  { "foreign.cdv_reason_id" => "self.cdv_reason_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sJShN70kTvBlxwxFa+mZMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
