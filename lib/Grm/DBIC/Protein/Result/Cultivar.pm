package Grm::DBIC::Protein::Result::Cultivar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Cultivar

=cut

__PACKAGE__->table("cultivar");

=head1 ACCESSORS

=head2 cultivar_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 cultivar_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "cultivar_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "species_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "cultivar_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("cultivar_id");

=head1 RELATIONS

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Protein::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 cultivar_synonyms

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::CultivarSynonym>

=cut

__PACKAGE__->has_many(
  "cultivar_synonyms",
  "Grm::DBIC::Protein::Result::CultivarSynonym",
  { "foreign.cultivar_id" => "self.cultivar_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_product_to_cultivars

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToCultivar>

=cut

__PACKAGE__->has_many(
  "gene_product_to_cultivars",
  "Grm::DBIC::Protein::Result::GeneProductToCultivar",
  { "foreign.cultivar_id" => "self.cultivar_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W5SbsE7KjwYl5oGmQsWAlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
