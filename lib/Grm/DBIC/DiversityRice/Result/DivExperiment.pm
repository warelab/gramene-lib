package Grm::DBIC::DiversityRice::Result::DivExperiment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::DivExperiment

=cut

__PACKAGE__->table("div_experiment");

=head1 ACCESSORS

=head2 div_experiment_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_experiment_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 design

  data_type: 'text'
  is_nullable: 1

=head2 originator

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_experiment_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_experiment_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "design",
  { data_type => "text", is_nullable => 1 },
  "originator",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_experiment_id");

=head1 RELATIONS

=head2 div_obs_units

Type: has_many

Related object: L<Grm::DBIC::DiversityRice::Result::DivObsUnit>

=cut

__PACKAGE__->has_many(
  "div_obs_units",
  "Grm::DBIC::DiversityRice::Result::DivObsUnit",
  { "foreign.div_experiment_id" => "self.div_experiment_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7mYA9JUmepN/wIULLXxuSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
