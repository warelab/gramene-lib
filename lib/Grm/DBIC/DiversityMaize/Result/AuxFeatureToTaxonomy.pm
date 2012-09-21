package Grm::DBIC::DiversityMaize::Result::AuxFeatureToTaxonomy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AuxFeatureToTaxonomy

=cut

__PACKAGE__->table("aux_feature_to_taxonomy");

=head1 ACCESSORS

=head2 aux_feature_to_taxonomy_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_id

  data_type: 'integer'
  is_nullable: 1

=head2 cdv_marker_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_allele_assay_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_scoring_tech_type_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_allele_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_obs_unit_sample_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_obs_unit_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_stock_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_passport_id

  data_type: 'integer'
  is_nullable: 1

=head2 div_taxonomy_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_feature_to_taxonomy_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cdv_map_feature_id",
  { data_type => "integer", is_nullable => 1 },
  "cdv_marker_id",
  { data_type => "integer", is_nullable => 1 },
  "div_allele_assay_id",
  { data_type => "integer", is_nullable => 1 },
  "div_scoring_tech_type_id",
  { data_type => "integer", is_nullable => 1 },
  "div_allele_id",
  { data_type => "integer", is_nullable => 1 },
  "div_obs_unit_sample_id",
  { data_type => "integer", is_nullable => 1 },
  "div_obs_unit_id",
  { data_type => "integer", is_nullable => 1 },
  "div_stock_id",
  { data_type => "integer", is_nullable => 1 },
  "div_passport_id",
  { data_type => "integer", is_nullable => 1 },
  "div_taxonomy_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_feature_to_taxonomy_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2OieZNp0rDhL7nIFhRuBwA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
