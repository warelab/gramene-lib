use utf8;
package Grm::DBIC::Pathway::Result::Pathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Pathway::Result::Pathway

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<pathway>

=cut

__PACKAGE__->table("pathway");

=head1 ACCESSORS

=head2 search_id

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
  "search_id",
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

=head1 PRIMARY KEY

=over 4

=item * L</search_id>

=back

=cut

__PACKAGE__->set_primary_key("search_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2014-05-16 10:47:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pOh5mOGTiD0D7oqqNFakUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
