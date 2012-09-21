package Grm::DBIC::DiversitySorghum::Result::DivAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivAllele

=cut

__PACKAGE__->table("div_allele");

=head1 ACCESSORS

=head2 div_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_obs_unit_sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 div_allele_assay_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 accession

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 referencedb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 allele_num

  data_type: 'integer'
  is_nullable: 1

=head2 quality

  data_type: 'text'
  is_nullable: 1

=head2 value

  data_type: 'text'
  is_nullable: 1

=head2 proportion

  data_type: 'double precision'
  is_nullable: 1

=head2 total_n

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_allele_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_obs_unit_sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "div_allele_assay_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "accession",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "referencedb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "allele_num",
  { data_type => "integer", is_nullable => 1 },
  "quality",
  { data_type => "text", is_nullable => 1 },
  "value",
  { data_type => "text", is_nullable => 1 },
  "proportion",
  { data_type => "double precision", is_nullable => 1 },
  "total_n",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_allele_id");

=head1 RELATIONS

=head2 cdv_allele_curated_alleles

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::CdvAlleleCuratedAllele>

=cut

__PACKAGE__->has_many(
  "cdv_allele_curated_alleles",
  "Grm::DBIC::DiversitySorghum::Result::CdvAlleleCuratedAllele",
  { "foreign.div_allele_id" => "self.div_allele_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_allele_assay

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivAlleleAssay>

=cut

__PACKAGE__->belongs_to(
  "div_allele_assay",
  "Grm::DBIC::DiversitySorghum::Result::DivAlleleAssay",
  { div_allele_assay_id => "div_allele_assay_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_obs_unit_sample

Type: belongs_to

Related object: L<Grm::DBIC::DiversitySorghum::Result::DivObsUnitSample>

=cut

__PACKAGE__->belongs_to(
  "div_obs_unit_sample",
  "Grm::DBIC::DiversitySorghum::Result::DivObsUnitSample",
  { div_obs_unit_sample_id => "div_obs_unit_sample_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sPpAsZhVNGh79ubaMjnNCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
