package Grm::DBIC::DiversitySorghum::Result::DivPassport;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivPassport

=cut

__PACKAGE__->table("div_passport");

=head1 ACCESSORS

=head2 div_passport_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_passport_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_taxonomy_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_accession_collecting_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 cdv_source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 accename

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 accenumb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sampstat

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_passport_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_passport_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_taxonomy_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_accession_collecting_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "cdv_source_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "accename",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "accenumb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sampstat",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_passport_id");
__PACKAGE__->add_unique_constraint("accename", ["accename"]);

=head1 RELATIONS

=head2 cdv_passport_sets

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::CdvPassportSet>

=cut

__PACKAGE__->has_many(
  "cdv_passport_sets",
  "Grm::DBIC::DiversitySorghum::Result::CdvPassportSet",
  { "foreign.div_passport_id" => "self.div_passport_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_taxonomy

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivTaxonomy>

=cut

__PACKAGE__->belongs_to(
  "div_taxonomy",
  "Grm::DBIC::DiversitySorghum::Result::DivTaxonomy",
  { div_taxonomy_id => "div_taxonomy_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_accession_collecting

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivAccessionCollecting>

=cut

__PACKAGE__->belongs_to(
  "div_accession_collecting",
  "Grm::DBIC::DiversitySorghum::Result::DivAccessionCollecting",
  { div_accession_collecting_id => "div_accession_collecting_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cdv_source

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::CdvSource>

=cut

__PACKAGE__->belongs_to(
  "cdv_source",
  "Grm::DBIC::DiversitySorghum::Result::CdvSource",
  { cdv_source_id => "cdv_source_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_stocks

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivStock>

=cut

__PACKAGE__->has_many(
  "div_stocks",
  "Grm::DBIC::DiversitySorghum::Result::DivStock",
  { "foreign.div_passport_id" => "self.div_passport_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_synonyms

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivSynonym>

=cut

__PACKAGE__->has_many(
  "div_synonyms",
  "Grm::DBIC::DiversitySorghum::Result::DivSynonym",
  { "foreign.div_passport_id" => "self.div_passport_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V0S8frqXs50hVYGdKQUu6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
