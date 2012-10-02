package Grm::DBIC::Ensembl::Result::UnconventionalTranscriptAssociation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::UnconventionalTranscriptAssociation

=cut

__PACKAGE__->table("unconventional_transcript_association");

=head1 ACCESSORS

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 interaction_type

  data_type: 'enum'
  extra: {list => ["antisense","sense_intronic","sense_overlaping_exonic","chimeric_sense_exonic"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "gene_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "interaction_type",
  {
    data_type => "enum",
    extra => {
      list => [
        "antisense",
        "sense_intronic",
        "sense_overlaping_exonic",
        "chimeric_sense_exonic",
      ],
    },
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jnVG7LPUNt/y27urLoqlQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
