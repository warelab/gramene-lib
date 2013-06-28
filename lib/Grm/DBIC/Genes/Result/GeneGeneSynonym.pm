package Grm::DBIC::Genes::Result::GeneGeneSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneGeneSynonym

=cut

__PACKAGE__->table("gene_gene_synonym");

=head1 ACCESSORS

=head2 gene_synonym_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 synonym_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "gene_synonym_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "gene_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "synonym_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("gene_synonym_id");

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QI71z0GICdrqBekQfF2JeA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
