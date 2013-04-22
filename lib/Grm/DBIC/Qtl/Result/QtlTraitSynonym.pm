package Grm::DBIC::Qtl::Result::QtlTraitSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::QtlTraitSynonym

=cut

__PACKAGE__->table("qtl_trait_synonym");

=head1 ACCESSORS

=head2 qtl_trait_synonym_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_trait_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 trait_synonym

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=cut

__PACKAGE__->add_columns(
  "qtl_trait_synonym_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "qtl_trait_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "trait_synonym",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
);
__PACKAGE__->set_primary_key("qtl_trait_synonym_id");
__PACKAGE__->add_unique_constraint("qtl_trait_id_2", ["qtl_trait_id", "trait_synonym"]);

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:shTv3vkXa7MjDDZwx9n4BA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
