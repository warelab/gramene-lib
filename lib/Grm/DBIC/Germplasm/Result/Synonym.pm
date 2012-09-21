package Grm::DBIC::Germplasm::Result::Synonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Germplasm::Result::Synonym

=cut

__PACKAGE__->table("synonym");

=head1 ACCESSORS

=head2 synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 synonym_type_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 germplasm_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 is_display_name

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "synonym_type_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "germplasm_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "is_display_name",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("synonym_id");
__PACKAGE__->add_unique_constraint("germplasm_id", ["germplasm_id", "name"]);

=head1 RELATIONS

=head2 germplasm

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::Germplasm>

=cut

__PACKAGE__->belongs_to(
  "germplasm",
  "Grm::DBIC::Germplasm::Result::Germplasm",
  { germplasm_id => "germplasm_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 synonym_type

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::SynonymType>

=cut

__PACKAGE__->belongs_to(
  "synonym_type",
  "Grm::DBIC::Germplasm::Result::SynonymType",
  { synonym_type_id => "synonym_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:02:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:x7X35tM8dm+oFHuR8DDgWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
