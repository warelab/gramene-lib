package Grm::DBIC::Compara::Result::SpeciesSetTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::SpeciesSetTag

=cut

__PACKAGE__->table("species_set_tag");

=head1 ACCESSORS

=head2 species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 tag

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 value

  data_type: 'mediumtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "species_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "tag",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "value",
  { data_type => "mediumtext", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("tag_species_set_id", ["species_set_id", "tag"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e/fe0dRcqNjq72bDuKuLnw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
