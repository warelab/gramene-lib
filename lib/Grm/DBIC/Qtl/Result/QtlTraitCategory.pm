package Grm::DBIC::Qtl::Result::QtlTraitCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::QtlTraitCategory

=cut

__PACKAGE__->table("qtl_trait_category");

=head1 ACCESSORS

=head2 qtl_trait_category_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 trait_category

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 to_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "qtl_trait_category_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "trait_category",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "to_accession",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);
__PACKAGE__->set_primary_key("qtl_trait_category_id");
__PACKAGE__->add_unique_constraint("trait_category", ["trait_category"]);

=head1 RELATIONS

=head2 qtl_traits

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::QtlTrait>

=cut

__PACKAGE__->has_many(
  "qtl_traits",
  "Grm::DBIC::Qtl::Result::QtlTrait",
  { "foreign.qtl_trait_category_id" => "self.qtl_trait_category_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G8nwLmF+UlRj/xEj3IWubw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
