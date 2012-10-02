package Grm::DBIC::Ensembl::Result::GeneArchive;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::GeneArchive

=cut

__PACKAGE__->table("gene_archive");

=head1 ACCESSORS

=head2 gene_stable_id

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 gene_version

  data_type: 'smallint'
  default_value: 1
  is_nullable: 0

=head2 transcript_stable_id

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 transcript_version

  data_type: 'smallint'
  default_value: 1
  is_nullable: 0

=head2 translation_stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 translation_version

  data_type: 'smallint'
  default_value: 1
  is_nullable: 0

=head2 peptide_archive_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mapping_session_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "gene_stable_id",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "gene_version",
  { data_type => "smallint", default_value => 1, is_nullable => 0 },
  "transcript_stable_id",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "transcript_version",
  { data_type => "smallint", default_value => 1, is_nullable => 0 },
  "translation_stable_id",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "translation_version",
  { data_type => "smallint", default_value => 1, is_nullable => 0 },
  "peptide_archive_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "mapping_session_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n9xfmfQk2iBnxcdN93aC7Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
