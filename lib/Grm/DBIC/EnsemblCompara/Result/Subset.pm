package Grm::DBIC::EnsemblCompara::Result::Subset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::Subset

=cut

__PACKAGE__->table("subset");

=head1 ACCESSORS

=head2 subset_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 dump_loc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "subset_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "dump_loc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("subset_id");
__PACKAGE__->add_unique_constraint("description", ["description"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Gw/HM/hNOI5/VhLVXLKr+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
