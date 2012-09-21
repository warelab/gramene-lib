package Grm::DBIC::DiversityRice::Result::GrmSnpGeneCache;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::GrmSnpGeneCache

=cut

__PACKAGE__->table("grm_snp_gene_cache");

=head1 ACCESSORS

=head2 grm_snp_gene_cache

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 chromosome

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 gene_stable_id

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "grm_snp_gene_cache",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "chromosome",
  { data_type => "char", is_nullable => 1, size => 10 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "gene_stable_id",
  { data_type => "varchar", is_nullable => 0, size => 128 },
);
__PACKAGE__->set_primary_key("grm_snp_gene_cache");
__PACKAGE__->add_unique_constraint("chromosome", ["chromosome", "position", "gene_stable_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eI5sYPnTSLMuxslcq84rbA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
