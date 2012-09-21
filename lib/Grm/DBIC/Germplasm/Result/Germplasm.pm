package Grm::DBIC::Germplasm::Result::Germplasm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Germplasm::Result::Germplasm

=cut

__PACKAGE__->table("germplasm");

=head1 ACCESSORS

=head2 germplasm_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 species_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 germplasm_acc

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "germplasm_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "species_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "germplasm_acc",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 30 },
);
__PACKAGE__->set_primary_key("germplasm_id");
__PACKAGE__->add_unique_constraint("germplasm_acc", ["germplasm_acc"]);

=head1 RELATIONS

=head2 associations

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::Association>

=cut

__PACKAGE__->has_many(
  "associations",
  "Grm::DBIC::Germplasm::Result::Association",
  { "foreign.germplasm_id" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 species

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::Species>

=cut

__PACKAGE__->belongs_to(
  "species",
  "Grm::DBIC::Germplasm::Result::Species",
  { species_id => "species_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 germplasm_correspondence_germplasm_id1s

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::GermplasmCorrespondence>

=cut

__PACKAGE__->has_many(
  "germplasm_correspondence_germplasm_id1s",
  "Grm::DBIC::Germplasm::Result::GermplasmCorrespondence",
  { "foreign.germplasm_id1" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 germplasm_correspondence_germplasm_id2s

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::GermplasmCorrespondence>

=cut

__PACKAGE__->has_many(
  "germplasm_correspondence_germplasm_id2s",
  "Grm::DBIC::Germplasm::Result::GermplasmCorrespondence",
  { "foreign.germplasm_id2" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 phenotypes

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::Phenotype>

=cut

__PACKAGE__->has_many(
  "phenotypes",
  "Grm::DBIC::Germplasm::Result::Phenotype",
  { "foreign.germplasm_id" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 synonyms

Type: has_many

Related object: L<Grm::DBIC::Germplasm::Result::Synonym>

=cut

__PACKAGE__->has_many(
  "synonyms",
  "Grm::DBIC::Germplasm::Result::Synonym",
  { "foreign.germplasm_id" => "self.germplasm_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:02:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gNmAmOSweBcLgRdltpa4/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
