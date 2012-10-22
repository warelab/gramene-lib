package Grm::DBIC::Compara::Result::Member;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::Member

=cut

__PACKAGE__->table("member");

=head1 ACCESSORS

=head2 member_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 version

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 source_name

  accessor: undef
  data_type: 'enum'
  extra: {list => ["ENSEMBLGENE","ENSEMBLPEP","Uniprot/SPTREMBL","Uniprot/SWISSPROT","ENSEMBLTRANS","EXTERNALCDS"]}
  is_nullable: 0

=head2 taxon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 genome_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 sequence_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gene_member_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 chr_name

  data_type: 'char'
  is_nullable: 1
  size: 40

=head2 chr_start

  data_type: 'integer'
  is_nullable: 1

=head2 chr_end

  data_type: 'integer'
  is_nullable: 1

=head2 chr_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 display_label

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "member_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "stable_id",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "version",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "source_name",
  {
    accessor    => undef,
    data_type   => "enum",
    extra       => {
                     list => [
                       "ENSEMBLGENE",
                       "ENSEMBLPEP",
                       "Uniprot/SPTREMBL",
                       "Uniprot/SWISSPROT",
                       "ENSEMBLTRANS",
                       "EXTERNALCDS",
                     ],
                   },
    is_nullable => 0,
  },
  "taxon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "genome_db_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "sequence_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gene_member_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "chr_name",
  { data_type => "char", is_nullable => 1, size => 40 },
  "chr_start",
  { data_type => "integer", is_nullable => 1 },
  "chr_end",
  { data_type => "integer", is_nullable => 1 },
  "chr_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "display_label",
  { data_type => "varchar", is_nullable => 1, size => 128 },
);
__PACKAGE__->set_primary_key("member_id");
__PACKAGE__->add_unique_constraint("source_stable_id", ["stable_id", "source_name"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/rEbh4rJwn1mBmkZNHG9AA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
