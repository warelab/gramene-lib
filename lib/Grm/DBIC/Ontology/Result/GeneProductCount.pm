package Grm::DBIC::Ontology::Result::GeneProductCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ontology::Result::GeneProductCount

=cut

__PACKAGE__->table("gene_product_count");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 speciesdbname

  data_type: 'varchar'
  is_nullable: 1
  size: 55

=head2 species_id

  data_type: 'integer'
  is_nullable: 1

=head2 product_count

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "code",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "speciesdbname",
  { data_type => "varchar", is_nullable => 1, size => 55 },
  "species_id",
  { data_type => "integer", is_nullable => 1 },
  "product_count",
  { data_type => "integer", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-15 12:46:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/EL+JeqbCER2/7Swy0Ewyw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
