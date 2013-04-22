package Grm::DBIC::Qtl::Result::QtlTrait;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::QtlTrait

=cut

__PACKAGE__->table("qtl_trait");

=head1 ACCESSORS

=head2 qtl_trait_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_trait_category_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 trait_symbol

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 trait_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=head2 to_accession

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "qtl_trait_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "qtl_trait_category_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "trait_symbol",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "trait_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
  "to_accession",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 30 },
);
__PACKAGE__->set_primary_key("qtl_trait_id");
__PACKAGE__->add_unique_constraint("trait_symbol", ["trait_symbol"]);
__PACKAGE__->add_unique_constraint("trait_name", ["trait_name"]);

=head1 RELATIONS

=head2 qtls

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::Qtl>

=cut

__PACKAGE__->has_many(
  "qtls",
  "Grm::DBIC::Qtl::Result::Qtl",
  { "foreign.qtl_trait_id" => "self.qtl_trait_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 qtl_trait_category

Type: belongs_to

Related object: L<Grm::DBIC::Qtl::Result::QtlTraitCategory>

=cut

__PACKAGE__->belongs_to(
  "qtl_trait_category",
  "Grm::DBIC::Qtl::Result::QtlTraitCategory",
  { qtl_trait_category_id => "qtl_trait_category_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 qtl_trait_synonyms

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::QtlTraitSynonym>

=cut

__PACKAGE__->has_many(
  "qtl_trait_synonyms",
  "Grm::DBIC::Qtl::Result::QtlTraitSynonym",
  { "foreign.qtl_trait_id" => "self.qtl_trait_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dxgj9FUeGds/otqSwmA+QA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
