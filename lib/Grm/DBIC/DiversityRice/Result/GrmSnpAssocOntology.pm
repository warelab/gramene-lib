package Grm::DBIC::DiversityRice::Result::GrmSnpAssocOntology;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::GrmSnpAssocOntology

=cut

__PACKAGE__->table("grm_snp_assoc_ontology");

=head1 ACCESSORS

=head2 grm_snp_assoc_ontology_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 grm_snp_assoc_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 term

  data_type: 'char'
  is_nullable: 1
  size: 15

=cut

__PACKAGE__->add_columns(
  "grm_snp_assoc_ontology_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "grm_snp_assoc_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "term",
  { data_type => "char", is_nullable => 1, size => 15 },
);
__PACKAGE__->set_primary_key("grm_snp_assoc_ontology_id");
__PACKAGE__->add_unique_constraint("grm_snp_assoc_id_2", ["grm_snp_assoc_id", "term"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r9R6Kdg+B7QvkcdivDaOwg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
