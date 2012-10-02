package Grm::DBIC::Ensembl::Result::OperonTranscriptGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::OperonTranscriptGene

=cut

__PACKAGE__->table("operon_transcript_gene");

=head1 ACCESSORS

=head2 operon_transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "operon_transcript_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gene_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rvSINRqxqAGfYxiheVhodQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
