package Grm::DBIC::Protein::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 species_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 ncbi_taxa_id

  data_type: 'integer'
  is_nullable: 1

=head2 common_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 lineage_string

  data_type: 'text'
  is_nullable: 1

=head2 genus

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "species_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "ncbi_taxa_id",
  { data_type => "integer", is_nullable => 1 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "lineage_string",
  { data_type => "text", is_nullable => 1 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);
__PACKAGE__->set_primary_key("species_id");

=head1 RELATIONS

=head2 cultivars

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::Cultivar>

=cut

__PACKAGE__->has_many(
  "cultivars",
  "Grm::DBIC::Protein::Result::Cultivar",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_products

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProduct>

=cut

__PACKAGE__->has_many(
  "gene_products",
  "Grm::DBIC::Protein::Result::GeneProduct",
  { "foreign.species_id" => "self.species_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:55:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YsPhn/o3IqKInyVQ0RKMmg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
