package Grm::DBIC::Diversity::Result::DivLocality;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::DivLocality

=cut

__PACKAGE__->table("div_locality");

=head1 ACCESSORS

=head2 div_locality_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_locality_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 elevation

  data_type: 'integer'
  is_nullable: 1

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 origcty

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 locality_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 state_province

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_locality_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_locality_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "elevation",
  { data_type => "integer", is_nullable => 1 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "origcty",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "locality_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "state_province",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_locality_id");

=head1 RELATIONS

=head2 div_accession_collectings

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::DivAccessionCollecting>

=cut

__PACKAGE__->has_many(
  "div_accession_collectings",
  "Grm::DBIC::Diversity::Result::DivAccessionCollecting",
  { "foreign.div_locality_id" => "self.div_locality_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 div_obs_units

Type: has_many

Related object: L<Grm::DBIC::Diversity::Result::DivObsUnit>

=cut

__PACKAGE__->has_many(
  "div_obs_units",
  "Grm::DBIC::Diversity::Result::DivObsUnit",
  { "foreign.div_locality_id" => "self.div_locality_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TOPwUO0hO+DqvozEujee5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
