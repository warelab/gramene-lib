package Grm::DBIC::Maps::Result::FeatureRelationType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureRelationType

=cut

__PACKAGE__->table("feature_relation_type");

=head1 ACCESSORS

=head2 feature_relation_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
  "feature_relation_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
);
__PACKAGE__->set_primary_key("feature_relation_type_id");
__PACKAGE__->add_unique_constraint("type", ["type"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-11-06 17:03:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WglXbKEJIX4xL7XCuSBRSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
