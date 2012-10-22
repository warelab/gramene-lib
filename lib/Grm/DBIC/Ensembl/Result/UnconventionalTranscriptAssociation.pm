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

=head2 unconventional_transcript_association_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 interaction_type

  data_type: 'enum'
  extra: {list => ["antisense","sense_intronic","sense_overlaping_exonic","chimeric_sense_exonic"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "unconventional_transcript_association_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "transcript_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
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
__PACKAGE__->set_primary_key("unconventional_transcript_association_id");

=head1 RELATIONS

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Ensembl::Result::Gene",
  { gene_id => "gene_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 transcript

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Transcript>

=cut

__PACKAGE__->belongs_to(
  "transcript",
  "Grm::DBIC::Ensembl::Result::Transcript",
  { transcript_id => "transcript_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X/v4/l+vmRzxw3XENA4+AQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
