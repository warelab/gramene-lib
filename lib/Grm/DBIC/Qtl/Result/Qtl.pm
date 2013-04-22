package Grm::DBIC::Qtl::Result::Qtl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::Qtl

=cut

__PACKAGE__->table("qtl");

=head1 ACCESSORS

=head2 qtl_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_trait_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 qtl_accession_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 published_symbol

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 linkage_group

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 chromosome

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 cmap_map_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 30

=head2 start_position

  data_type: 'double precision'
  default_value: 0.00
  is_nullable: 0
  size: [11,2]

=head2 stop_position

  data_type: 'double precision'
  default_value: 0.00
  is_nullable: 0
  size: [11,2]

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "qtl_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "qtl_trait_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "species_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "qtl_accession_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "published_symbol",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "linkage_group",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "chromosome",
  { data_type => "char", is_nullable => 1, size => 10 },
  "cmap_map_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 30 },
  "start_position",
  {
    data_type => "double precision",
    default_value => "0.00",
    is_nullable => 0,
    size => [11, 2],
  },
  "stop_position",
  {
    data_type => "double precision",
    default_value => "0.00",
    is_nullable => 0,
    size => [11, 2],
  },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("qtl_id");
__PACKAGE__->add_unique_constraint("qtl_accession_id", ["qtl_accession_id"]);

=head1 RELATIONS

=head2 qtl_trait

Type: belongs_to

Related object: L<Grm::DBIC::Qtl::Result::QtlTrait>

=cut

__PACKAGE__->belongs_to(
  "qtl_trait",
  "Grm::DBIC::Qtl::Result::QtlTrait",
  { qtl_trait_id => "qtl_trait_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Qtl::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Qtl::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 qtl_associations

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::QtlAssociation>

=cut

__PACKAGE__->has_many(
  "qtl_associations",
  "Grm::DBIC::Qtl::Result::QtlAssociation",
  { "foreign.qtl_id" => "self.qtl_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qsfd8uIE1mTpzeAa/PXiSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
