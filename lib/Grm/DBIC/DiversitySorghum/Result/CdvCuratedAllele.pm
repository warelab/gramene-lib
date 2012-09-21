package Grm::DBIC::DiversitySorghum::Result::CdvCuratedAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::CdvCuratedAllele

=cut

__PACKAGE__->table("cdv_curated_allele");

=head1 ACCESSORS

=head2 cdv_curated_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_curated_allele_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cdv_curated_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_curated_allele_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("cdv_curated_allele_id");

=head1 RELATIONS

=head2 cdv_allele_curated_alleles

Type: has_many

Related object: L<Grm::DBIC::DiversitySorghum::Result::CdvAlleleCuratedAllele>

=cut

__PACKAGE__->has_many(
  "cdv_allele_curated_alleles",
  "Grm::DBIC::DiversitySorghum::Result::CdvAlleleCuratedAllele",
  { "foreign.cdv_curated_allele_id" => "self.cdv_curated_allele_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CTZIRCW/eDCrHqfS20orbg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
