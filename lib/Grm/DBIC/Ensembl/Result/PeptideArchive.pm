package Grm::DBIC::Ensembl::Result::PeptideArchive;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::PeptideArchive

=cut

__PACKAGE__->table("peptide_archive");

=head1 ACCESSORS

=head2 peptide_archive_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 md5_checksum

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 peptide_seq

  data_type: 'mediumtext'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "peptide_archive_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "md5_checksum",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "peptide_seq",
  { data_type => "mediumtext", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("peptide_archive_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GN2y3ct7ApA5rFsDSH7z8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
