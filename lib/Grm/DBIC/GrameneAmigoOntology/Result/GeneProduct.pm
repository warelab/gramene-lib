package Grm::DBIC::GrameneAmigoOntology::Result::GeneProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::GrameneAmigoOntology::Result::GeneProduct

=cut

__PACKAGE__->table("gene_product");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 symbol

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 dbxref_id

  data_type: 'integer'
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  is_nullable: 1

=head2 type_id

  data_type: 'integer'
  is_nullable: 1

=head2 full_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "symbol",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "dbxref_id",
  { data_type => "integer", is_nullable => 0 },
  "species_id",
  { data_type => "integer", is_nullable => 1 },
  "type_id",
  { data_type => "integer", is_nullable => 1 },
  "full_name",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("dbxref_id", ["dbxref_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h2nYUwL3Cb0hTZJGQbIcvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
