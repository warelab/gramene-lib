package Grm::DBIC::Maps::Result::FeatureDetailsEst;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsEst

=cut

__PACKAGE__->table("feature_details_est");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 clone

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 date_created

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 date_updated

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 lab_host

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 map

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 note

  data_type: 'text'
  is_nullable: 1

=head2 origin

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 ref_authors

  data_type: 'text'
  is_nullable: 1

=head2 ref_location

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 ref_medline

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 ref_pubmed

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 ref_title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ref_year

  data_type: 'integer'
  extra: {unsigned => 1}
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
  "clone",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "date_created",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "date_updated",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "lab_host",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "map",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "note",
  { data_type => "text", is_nullable => 1 },
  "origin",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "ref_authors",
  { data_type => "text", is_nullable => 1 },
  "ref_location",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "ref_medline",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "ref_pubmed",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "ref_title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ref_year",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YuHuEEIVey/Ri4rhYNGDpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
