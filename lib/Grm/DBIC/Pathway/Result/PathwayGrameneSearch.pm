package Grm::DBIC::Pathway::Result::PathwayGrameneSearch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Pathway::Result::PathwayGrameneSearch

=cut

__PACKAGE__->table("pathway_gramene_search");

=head1 ACCESSORS

=head2 pathway_gramene_search_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 gene_name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 enzyme_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 reaction_id

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 reaction_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 ec

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 pathway_id

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 pathway_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "pathway_gramene_search_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "gene_name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "enzyme_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "reaction_id",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "reaction_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "ec",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "pathway_id",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "pathway_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("pathway_gramene_search_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:16:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QBC3/3BCzZvm26Ovynv4Zw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
