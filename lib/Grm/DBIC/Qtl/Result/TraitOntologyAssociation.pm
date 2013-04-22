package Grm::DBIC::Qtl::Result::TraitOntologyAssociation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::TraitOntologyAssociation

=cut

__PACKAGE__->table("trait_ontology_association");

=head1 ACCESSORS

=head2 trait_ontology_association_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 to_accession

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 related_accession

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 species_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "trait_ontology_association_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "to_accession",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "related_accession",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "species_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("trait_ontology_association_id");
__PACKAGE__->add_unique_constraint(
  "to_accession_2",
  ["to_accession", "related_accession", "species_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9/tFpM2Gxu0luhwoMe5xQA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
