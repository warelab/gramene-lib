use utf8;
package Grm::DBIC::Ensembl::Result::TranscriptIntronSupportingEvidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::TranscriptIntronSupportingEvidence

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<transcript_intron_supporting_evidence>

=cut

__PACKAGE__->table("transcript_intron_supporting_evidence");

=head1 ACCESSORS

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 intron_supporting_evidence_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 previous_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 next_exon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "intron_supporting_evidence_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "previous_exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "next_exon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</intron_supporting_evidence_id>

=item * L</transcript_id>

=back

=cut

__PACKAGE__->set_primary_key("intron_supporting_evidence_id", "transcript_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kDKer5vfg5CSsjxRThKA/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
