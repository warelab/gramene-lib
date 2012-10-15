package Grm::DBIC::EnsemblCompara::Result::NcProfile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::NcProfile

=cut

__PACKAGE__->table("nc_profile");

=head1 ACCESSORS

=head2 model_id

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 type

  data_type: 'varchar'
  default_value: 'ncrna'
  is_nullable: 0
  size: 40

=head2 hc_profile

  data_type: 'mediumtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "model_id",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "type",
  {
    data_type => "varchar",
    default_value => "ncrna",
    is_nullable => 0,
    size => 40,
  },
  "hc_profile",
  { data_type => "mediumtext", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("model_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i/AyIWUD/Q84lWXPeLjixw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
