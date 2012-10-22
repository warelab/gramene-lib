package Grm::DBIC::Ensembl::Result::SplicingTranscriptPair;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::SplicingTranscriptPair

=cut

__PACKAGE__->table("splicing_transcript_pair");

=head1 ACCESSORS

=head2 splicing_transcript_pair_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 splicing_event_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 transcript_id_1

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 transcript_id_2

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "splicing_transcript_pair_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "splicing_event_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "transcript_id_1",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "transcript_id_2",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("splicing_transcript_pair_id");

=head1 RELATIONS

=head2 splicing_event

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SplicingEvent>

=cut

__PACKAGE__->belongs_to(
  "splicing_event",
  "Grm::DBIC::Ensembl::Result::SplicingEvent",
  { splicing_event_id => "splicing_event_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 transcript_id_1

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "transcript_id_1",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "transcript_id_1" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 transcript_id_2

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "transcript_id_2",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "transcript_id_2" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7yyjU+ydjf45HHtnFYPbTA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
