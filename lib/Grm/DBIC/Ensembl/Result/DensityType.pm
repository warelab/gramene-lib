use utf8;
package Grm::DBIC::Ensembl::Result::DensityType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::DensityType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<density_type>

=cut

__PACKAGE__->table("density_type");

=head1 ACCESSORS

=head2 density_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
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

=head1 PRIMARY KEY

=over 4

=item * L</density_type_id>

=back

=cut

__PACKAGE__->set_primary_key("density_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<analysis_idx>

=over 4

=item * L</analysis_id>

=item * L</block_size>

=item * L</region_features>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "analysis_idx",
  ["analysis_id", "block_size", "region_features"],
);

=head1 RELATIONS

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 density_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DensityFeature>

=cut

__PACKAGE__->has_many(
  "density_features",
  "Grm::DBIC::Ensembl::Result::DensityFeature",
  { "foreign.density_type_id" => "self.density_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:whPjhSjWYFtFI86fcMpsSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
