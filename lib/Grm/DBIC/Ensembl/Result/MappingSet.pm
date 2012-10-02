package Grm::DBIC::Ensembl::Result::MappingSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MappingSet

=cut

__PACKAGE__->table("mapping_set");

=head1 ACCESSORS

=head2 mapping_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 schema_build

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "mapping_set_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "schema_build",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("schema_build");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m/J+GugjVOZ5JgAqMV5mUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
