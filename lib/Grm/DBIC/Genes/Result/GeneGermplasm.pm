package Grm::DBIC::Genes::Result::GeneGermplasm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGermplasm

=cut

__PACKAGE__->table("gene_germplasm");

=head1 ACCESSORS

=head2 germplasm_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 geographical_location_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 mutagenesis_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 wild_type

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 species_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "germplasm_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "geographical_location_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "mutagenesis_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "wild_type",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "species_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("germplasm_id");
__PACKAGE__->add_unique_constraint("accession", ["accession"]);

=head1 RELATIONS

=head2 geographical_location

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneGeographicalLocation>

=cut

__PACKAGE__->belongs_to(
  "geographical_location",
  "Grm::DBIC::Genes::Result::GeneGeographicalLocation",
  { geographical_location_id => "geographical_location_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 mutagenesis

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneMutagenesis>

=cut

__PACKAGE__->belongs_to(
  "mutagenesis",
  "Grm::DBIC::Genes::Result::GeneMutagenesis",
  { mutagenesis_id => "mutagenesis_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gt1scJv0HAbFboF7kbtbZw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
