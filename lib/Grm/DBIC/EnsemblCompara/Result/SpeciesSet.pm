package Grm::DBIC::EnsemblCompara::Result::SpeciesSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::SpeciesSet

=cut

__PACKAGE__->table("species_set");

=head1 ACCESSORS

=head2 species_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 genome_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "species_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "genome_db_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("species_set_id", ["species_set_id", "genome_db_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mErJKVYYJQHLW31AudKwQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
