package Grm::DBIC::Ensembl::Result::SplicingEventFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::SplicingEventFeature

=cut

__PACKAGE__->table("splicing_event_feature");

=head1 ACCESSORS

=head2 splicing_event_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 splicing_event_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 feature_order

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 transcript_association

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["constitutive_exon","exon","flanking_exon"]}
  is_nullable: 1

=head2 start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "splicing_event_feature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "splicing_event_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "feature_order",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "transcript_association",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["constitutive_exon", "exon", "flanking_exon"] },
    is_nullable => 1,
  },
  "start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("splicing_event_feature_id", "exon_id", "transcript_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:moMoblYywzHuxxO71lkPXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
