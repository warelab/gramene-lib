package Grm::DBIC::Genes::Result::GeneMapPosition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneMapPosition

=cut

__PACKAGE__->table("gene_map_position");

=head1 ACCESSORS

=head2 map_position_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 cmap_feature_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 cmap_map_set

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 cmap_map_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 cmap_map_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 start_position

  data_type: 'double precision'
  default_value: 0.00
  is_nullable: 0
  size: [11,2]

=head2 stop_position

  data_type: 'double precision'
  is_nullable: 1
  size: [11,2]

=head2 map_units

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 12

=cut

__PACKAGE__->add_columns(
  "map_position_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gene_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "cmap_feature_accession",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "cmap_map_set",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "cmap_map_accession",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "cmap_map_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "start_position",
  {
    data_type => "double precision",
    default_value => "0.00",
    is_nullable => 0,
    size => [11, 2],
  },
  "stop_position",
  { data_type => "double precision", is_nullable => 1, size => [11, 2] },
  "map_units",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 12 },
);
__PACKAGE__->set_primary_key("map_position_id");
__PACKAGE__->add_unique_constraint("cmap_feature_accession_2", ["cmap_feature_accession"]);

=head1 RELATIONS

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Genes::Result::GeneGene",
  { gene_id => "gene_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gNytofRAI9n3nwqAk0WF2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
