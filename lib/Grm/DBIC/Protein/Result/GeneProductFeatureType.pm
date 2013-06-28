package Grm::DBIC::Protein::Result::GeneProductFeatureType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::GeneProductFeatureType

=cut

__PACKAGE__->table("gene_product_feature_type");

=head1 ACCESSORS

=head2 feature_type_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 feature_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "feature_type_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "feature_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("feature_type_id");
__PACKAGE__->add_unique_constraint("feature_type", ["feature_type"]);

=head1 RELATIONS

=head2 gene_product_features

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductFeature>

=cut

__PACKAGE__->has_many(
  "gene_product_features",
  "Grm::DBIC::Protein::Result::GeneProductFeature",
  { "foreign.feature_type_id" => "self.feature_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OiyUk4zYXzr2EhuP3oQwtw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
