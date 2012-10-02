package Grm::DBIC::Ensembl::Result::PredictionExon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::PredictionExon

=cut

__PACKAGE__->table("prediction_exon");

=head1 ACCESSORS

=head2 prediction_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 prediction_transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 exon_rank

  data_type: 'smallint'
  extra: {unsigned => 1}
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
  is_nullable: 0

=head2 start_phase

  data_type: 'tinyint'
  is_nullable: 0

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=head2 p_value

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "prediction_exon_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "prediction_transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "exon_rank",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "start_phase",
  { data_type => "tinyint", is_nullable => 0 },
  "score",
  { data_type => "double precision", is_nullable => 1 },
  "p_value",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("prediction_exon_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OpONdiO8fBT8/kg7huNKFQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
