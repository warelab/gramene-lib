use utf8;
package Grm::DBIC::Ensembl::Result::GeneArchive;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::GeneArchive

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<gene_archive>

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
  is_foreign_key: 1
  is_nullable: 1

=head2 mapping_session_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "mapping_session_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 RELATIONS

=head2 mapping_session

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MappingSession>

=cut

__PACKAGE__->belongs_to(
  "mapping_session",
  "Grm::DBIC::Ensembl::Result::MappingSession",
  { mapping_session_id => "mapping_session_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 peptide_archive

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::PeptideArchive>

=cut

__PACKAGE__->belongs_to(
  "peptide_archive",
  "Grm::DBIC::Ensembl::Result::PeptideArchive",
  { peptide_archive_id => "peptide_archive_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wdWnpI/kzic+CrZNJ5+1cA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
