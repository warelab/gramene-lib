package Grm::DBIC::Maps::Result::FeatureDetailsGenomicDna;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsGenomicDna

=cut

__PACKAGE__->table("feature_details_genomic_dna");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 ec_number

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 allele

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 bound_moiety

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cell_line

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 cell_type

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 chromosome

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 citation

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 clone

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 clone_lib

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 codon_start

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 compare

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 cons_splice

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 dev_stage

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ecotype

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 evidence

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 exception

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 function

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 gene

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 germline

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 haplotype

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 insertion_seq

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 isolate

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 isolation_source

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 keyword

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 lab_host

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 label

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 locus_tag

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 macronuclear

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 map

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 mod_base

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 mol_type

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 note

  data_type: 'text'
  is_nullable: 1

=head2 number

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 origin

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 patent

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 phenotype

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 plasmid

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 pop_variant

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 product

  data_type: 'text'
  is_nullable: 1

=head2 protein_id

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 pseudo

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 rearranged

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 ref_authors

  data_type: 'text'
  is_nullable: 1

=head2 ref_location

  data_type: 'text'
  is_nullable: 1

=head2 ref_pubmed

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 ref_title

  data_type: 'text'
  is_nullable: 1

=head2 ref_year

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 rpt_family

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 rpt_type

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 rpt_unit

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 sex

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 specimen_voucher

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 standard_name

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 sub_clone

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 sub_species

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 sub_strain

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 tissue_lib

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 tissue_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 transl_except

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 transl_table

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 translation

  data_type: 'text'
  is_nullable: 1

=head2 transposon

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 variety

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "ec_number",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "allele",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "bound_moiety",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cell_line",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "cell_type",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "chromosome",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "citation",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "clone",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "clone_lib",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "codon_start",
  { data_type => "char", is_nullable => 1, size => 2 },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "compare",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "cons_splice",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "dev_stage",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ecotype",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "evidence",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "exception",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "function",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "gene",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "germline",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "haplotype",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "insertion_seq",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "isolate",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "isolation_source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "keyword",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "lab_host",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "label",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "locus_tag",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "macronuclear",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "map",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "mod_base",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "mol_type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "note",
  { data_type => "text", is_nullable => 1 },
  "number",
  { data_type => "char", is_nullable => 1, size => 2 },
  "origin",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "patent",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "phenotype",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "plasmid",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "pop_variant",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "product",
  { data_type => "text", is_nullable => 1 },
  "protein_id",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "pseudo",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "rearranged",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "ref_authors",
  { data_type => "text", is_nullable => 1 },
  "ref_location",
  { data_type => "text", is_nullable => 1 },
  "ref_pubmed",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "ref_title",
  { data_type => "text", is_nullable => 1 },
  "ref_year",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "rpt_family",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "rpt_type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "rpt_unit",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "sex",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "specimen_voucher",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "standard_name",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "sub_clone",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "sub_species",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "sub_strain",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "tissue_lib",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "tissue_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "transl_except",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "transl_table",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "translation",
  { data_type => "text", is_nullable => 1 },
  "transposon",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "variety",
  { data_type => "varchar", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("feature_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5IlgAccO0MT0NkDFhJCoAg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
