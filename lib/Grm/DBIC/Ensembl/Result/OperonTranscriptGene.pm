use utf8;
package Grm::DBIC::Ensembl::Result::OperonTranscriptGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::OperonTranscriptGene

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<operon_transcript_gene>

=cut

__PACKAGE__->table("operon_transcript_gene");

=head1 ACCESSORS

=head2 operon_transcript_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "operon_transcript_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 RELATIONS

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Ensembl::Result::Gene",
  { gene_id => "gene_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 operon_transcript

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::OperonTranscript>

=cut

__PACKAGE__->belongs_to(
  "operon_transcript",
  "Grm::DBIC::Ensembl::Result::OperonTranscript",
  { operon_transcript_id => "operon_transcript_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EL3esbZxxsdfIJSW+mXpHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
