package Grm::DBIC::Protein::Result::CultivarSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::CultivarSynonym

=cut

__PACKAGE__->table("cultivar_synonym");

=head1 ACCESSORS

=head2 cultivar_synonym_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 cultivar_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 cultivar_synonym

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=cut

__PACKAGE__->add_columns(
  "cultivar_synonym_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "cultivar_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "cultivar_synonym",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
);
__PACKAGE__->set_primary_key("cultivar_synonym_id");
__PACKAGE__->add_unique_constraint("cultivar_id", ["cultivar_id", "cultivar_synonym"]);

=head1 RELATIONS

=head2 cultivar

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Cultivar>

=cut

__PACKAGE__->belongs_to(
  "cultivar",
  "Grm::DBIC::Protein::Result::Cultivar",
  { cultivar_id => "cultivar_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1WsRMQj3pq4Ot7McfC+HIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
