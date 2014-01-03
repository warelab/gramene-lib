use utf8;
package Grm::DBIC::Variation::Result::PhenotypeFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::PhenotypeFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<phenotype_feature>

=cut

__PACKAGE__->table("phenotype_feature");

=head1 ACCESSORS

=head2 phenotype_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 phenotype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 study_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 type

  data_type: 'enum'
  extra: {list => ["Gene","Variation","StructuralVariation","SupportingStructuralVariation","QTL","RegulatoryFeature"]}
  is_nullable: 1

=head2 object_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 is_significant

  data_type: 'tinyint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 1

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "phenotype_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "phenotype_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "study_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "type",
  {
    data_type => "enum",
    extra => {
      list => [
        "Gene",
        "Variation",
        "StructuralVariation",
        "SupportingStructuralVariation",
        "QTL",
        "RegulatoryFeature",
      ],
    },
    is_nullable => 1,
  },
  "object_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "is_significant",
  {
    data_type => "tinyint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</phenotype_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("phenotype_feature_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8QZ4Qu3ZHAtkjG8CaTvYFQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
