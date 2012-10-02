package Grm::DBIC::Ensembl::Result::RepeatFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::RepeatFeature

=cut

__PACKAGE__->table("repeat_feature");

=head1 ACCESSORS

=head2 repeat_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 repeat_start

  data_type: 'integer'
  is_nullable: 0

=head2 repeat_end

  data_type: 'integer'
  is_nullable: 0

=head2 repeat_consensus_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "repeat_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "repeat_start",
  { data_type => "integer", is_nullable => 0 },
  "repeat_end",
  { data_type => "integer", is_nullable => 0 },
  "repeat_consensus_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "score",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("repeat_feature_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IrJ8ODMKK2B99gPWfRfckA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
