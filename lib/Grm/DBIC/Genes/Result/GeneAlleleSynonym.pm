package Grm::DBIC::Genes::Result::GeneAlleleSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneAlleleSynonym

=cut

__PACKAGE__->table("gene_allele_synonym");

=head1 ACCESSORS

=head2 allele_synonym_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 allele_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 synonym_name

  data_type: 'varbinary'
  default_value: ' '
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "allele_synonym_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "allele_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "synonym_name",
  {
    data_type => "varbinary",
    default_value => " ",
    is_nullable => 0,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("allele_synonym_id");
__PACKAGE__->add_unique_constraint("allele_id", ["allele_id", "synonym_name"]);

=head1 RELATIONS

=head2 allele

Type: belongs_to

Related object: L<Grm::DBIC::Genes::Result::GeneAllele>

=cut

__PACKAGE__->belongs_to(
  "allele",
  "Grm::DBIC::Genes::Result::GeneAllele",
  { allele_id => "allele_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9uum0fbRgum15tsDpYpmlg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
