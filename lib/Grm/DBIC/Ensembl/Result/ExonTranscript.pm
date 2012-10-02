package Grm::DBIC::Ensembl::Result::ExonTranscript;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ExonTranscript

=cut

__PACKAGE__->table("exon_transcript");

=head1 ACCESSORS

=head2 exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rank

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "rank",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("exon_id", "transcript_id", "rank");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vJmQBBRs9vJsFmAtCaBV6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
