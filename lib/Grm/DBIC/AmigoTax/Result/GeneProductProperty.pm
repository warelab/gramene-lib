package Grm::DBIC::AmigoTax::Result::GeneProductProperty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTax::Result::GeneProductProperty

=cut

__PACKAGE__->table("gene_product_property");

=head1 ACCESSORS

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 property_key

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 property_val

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "property_key",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "property_val",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->add_unique_constraint("gppu4", ["gene_product_id", "property_key", "property_val"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:syytVwakRH6Ag7gS/W/V0A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
