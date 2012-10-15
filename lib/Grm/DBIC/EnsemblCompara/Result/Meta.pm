package Grm::DBIC::EnsemblCompara::Result::Meta;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::Meta

=cut

__PACKAGE__->table("meta");

=head1 ACCESSORS

=head2 meta_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 1

=head2 meta_key

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 meta_value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "meta_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "species_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "meta_key",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "meta_value",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("meta_id");
__PACKAGE__->add_unique_constraint(
  "species_key_value_idx",
  ["species_id", "meta_key", "meta_value"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZXi98kIimgH0pN0gCX5PXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
