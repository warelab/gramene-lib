package Grm::DBIC::Genes::Result::GeneMutagenesis;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneMutagenesis

=cut

__PACKAGE__->table("gene_mutagenesis");

=head1 ACCESSORS

=head2 mutagenesis_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 mutagen

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 mutagenesis_method

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "mutagenesis_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "mutagen",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "mutagenesis_method",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
);
__PACKAGE__->set_primary_key("mutagenesis_id");
__PACKAGE__->add_unique_constraint("mutagen", ["mutagen", "mutagenesis_method"]);

=head1 RELATIONS

=head2 gene_germplasms

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneGermplasm>

=cut

__PACKAGE__->has_many(
  "gene_germplasms",
  "Grm::DBIC::Genes::Result::GeneGermplasm",
  { "foreign.mutagenesis_id" => "self.mutagenesis_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LXDSEUU82FqporZVEQDwQg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
