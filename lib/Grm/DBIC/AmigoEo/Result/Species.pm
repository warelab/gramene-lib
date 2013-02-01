package Grm::DBIC::AmigoEo::Result::Species;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoEo::Result::Species

=cut

__PACKAGE__->table("species");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
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
  size: 55

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1

=head2 left_value

  data_type: 'integer'
  is_nullable: 1

=head2 right_value

  data_type: 'integer'
  is_nullable: 1

=head2 taxonomic_rank

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ncbi_taxa_id",
  { data_type => "integer", is_nullable => 1 },
  "common_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "lineage_string",
  { data_type => "text", is_nullable => 1 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 55 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "parent_id",
  { data_type => "integer", is_nullable => 1 },
  "left_value",
  { data_type => "integer", is_nullable => 1 },
  "right_value",
  { data_type => "integer", is_nullable => 1 },
  "taxonomic_rank",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("ncbi_taxa_id", ["ncbi_taxa_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AhfOx5Qgns/fFjTdAfa2kA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
