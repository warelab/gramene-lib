package Grm::DBIC::DiversityMaize::Result::DivStatisticType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivStatisticType

=cut

__PACKAGE__->table("div_statistic_type");

=head1 ACCESSORS

=head2 div_statistic_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_statistic_type_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 stat_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_statistic_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_statistic_type_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "stat_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_statistic_type_id");
__PACKAGE__->add_unique_constraint("div_statistic_type_acc", ["div_statistic_type_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iqYS21WBxKC/I1OJwz+kqA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
