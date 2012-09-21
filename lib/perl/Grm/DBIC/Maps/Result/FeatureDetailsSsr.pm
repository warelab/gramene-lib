package Grm::DBIC::Maps::Result::FeatureDetailsSsr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsSsr

=cut

__PACKAGE__->table("feature_details_ssr");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 repeat_motif

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 anneal_temperature

  data_type: 'integer'
  is_nullable: 1

=head2 product_size

  data_type: 'integer'
  is_nullable: 1

=head2 sequence_source

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 linkage_group

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 remarks

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "repeat_motif",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "anneal_temperature",
  { data_type => "integer", is_nullable => 1 },
  "product_size",
  { data_type => "integer", is_nullable => 1 },
  "sequence_source",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "linkage_group",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "remarks",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("feature_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cHs5FsKTfC+fGq/aa01+3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
