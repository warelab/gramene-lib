package Grm::DBIC::EnsemblCompara::Result::NcbiTaxaName;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::NcbiTaxaName

=cut

__PACKAGE__->table("ncbi_taxa_name");

=head1 ACCESSORS

=head2 taxon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name_class

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "taxon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name_class",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1RM+d7xpT1fnJbba61NS8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
