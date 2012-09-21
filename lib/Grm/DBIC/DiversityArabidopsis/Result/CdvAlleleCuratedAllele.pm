package Grm::DBIC::DiversityArabidopsis::Result::CdvAlleleCuratedAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::CdvAlleleCuratedAllele

=cut

__PACKAGE__->table("cdv_allele_curated_allele");

=head1 ACCESSORS

=head2 cdv_allele_curated_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_allele_curated_allele_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_curated_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 cdv_curation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_allele_curated_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_allele_curated_allele_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_curated_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "cdv_curation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("cdv_allele_curated_allele_id");

=head1 RELATIONS

=head2 cdv_curated_allele

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::CdvCuratedAllele>

=cut

__PACKAGE__->belongs_to(
  "cdv_curated_allele",
  "Grm::DBIC::DiversityArabidopsis::Result::CdvCuratedAllele",
  { cdv_curated_allele_id => "cdv_curated_allele_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 cdv_curation

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::CdvCuration>

=cut

__PACKAGE__->belongs_to(
  "cdv_curation",
  "Grm::DBIC::DiversityArabidopsis::Result::CdvCuration",
  { cdv_curation_id => "cdv_curation_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_allele

Type: belongs_to

Related object: L<Grm::DBIC::DiversityArabidopsis::Result::DivAllele>

=cut

__PACKAGE__->belongs_to(
  "div_allele",
  "Grm::DBIC::DiversityArabidopsis::Result::DivAllele",
  { div_allele_id => "div_allele_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VdKaFVuIwc1S+PwtfRbcgg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
