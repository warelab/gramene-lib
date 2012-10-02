package Grm::DBIC::Ensembl::Result::DensityType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::DensityType

=cut

__PACKAGE__->table("density_type");

=head1 ACCESSORS

=head2 density_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 block_size

  data_type: 'integer'
  is_nullable: 0

=head2 region_features

  data_type: 'integer'
  is_nullable: 0

=head2 value_type

  data_type: 'enum'
  extra: {list => ["sum","ratio"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "density_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "block_size",
  { data_type => "integer", is_nullable => 0 },
  "region_features",
  { data_type => "integer", is_nullable => 0 },
  "value_type",
  {
    data_type => "enum",
    extra => { list => ["sum", "ratio"] },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("density_type_id");
__PACKAGE__->add_unique_constraint(
  "analysis_idx",
  ["analysis_id", "block_size", "region_features"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tj85Sm4/Dy6Ul91saSCYRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
