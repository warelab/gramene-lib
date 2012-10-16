package Grm::DBIC::Amigo::Result::Homolset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Amigo::Result::Homolset

=cut

__PACKAGE__->table("homolset");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 symbol

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 dbxref_id

  data_type: 'integer'
  is_nullable: 1

=head2 target_gene_product_id

  data_type: 'integer'
  is_nullable: 1

=head2 taxon_id

  data_type: 'integer'
  is_nullable: 1

=head2 type_id

  data_type: 'integer'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "symbol",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "dbxref_id",
  { data_type => "integer", is_nullable => 1 },
  "target_gene_product_id",
  { data_type => "integer", is_nullable => 1 },
  "taxon_id",
  { data_type => "integer", is_nullable => 1 },
  "type_id",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("dbxref_id", ["dbxref_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-16 15:17:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+AEmgSUMh2RcyV8TGcOtvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
