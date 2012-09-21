package Grm::DBIC::DiversityMaize::Result::DivScoringTechType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivScoringTechType

=cut

__PACKAGE__->table("div_scoring_tech_type");

=head1 ACCESSORS

=head2 div_scoring_tech_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_scoring_tech_type_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 scoring_tech_group

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 scoring_tech_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_scoring_tech_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_scoring_tech_type_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "scoring_tech_group",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "scoring_tech_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_scoring_tech_type_id");
__PACKAGE__->add_unique_constraint("div_scoring_tech_type_acc", ["div_scoring_tech_type_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/WLy1i9aZRTwJ9QUZs+y5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
