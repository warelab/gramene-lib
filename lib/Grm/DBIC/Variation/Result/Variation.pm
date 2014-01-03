use utf8;
package Grm::DBIC::Variation::Result::Variation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Variation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<variation>

=cut

__PACKAGE__->table("variation");

=head1 ACCESSORS

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 validation_status

  data_type: 'set'
  extra: {list => ["cluster","freq","submitter","doublehit","hapmap","1000Genome","failed","precious"]}
  is_nullable: 1

=head2 ancestral_allele

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 flipped

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 class_attrib_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 somatic

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 minor_allele

  data_type: 'char'
  is_nullable: 1
  size: 50

=head2 minor_allele_freq

  data_type: 'float'
  is_nullable: 1

=head2 minor_allele_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 evidence

  data_type: 'set'
  extra: {list => ["Multiple_observations","Frequency","HapMap","1000Genomes","Cited"]}
  is_nullable: 1

=head2 clinical_significance

  data_type: 'set'
  extra: {list => ["drug-response","histocompatibility","non-pathogenic","other","pathogenic","probable-non-pathogenic","probable-pathogenic'unknown","untested"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "variation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "validation_status",
  {
    data_type => "set",
    extra => {
      list => [
        "cluster",
        "freq",
        "submitter",
        "doublehit",
        "hapmap",
        "1000Genome",
        "failed",
        "precious",
      ],
    },
    is_nullable => 1,
  },
  "ancestral_allele",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "flipped",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "class_attrib_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "somatic",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "minor_allele",
  { data_type => "char", is_nullable => 1, size => 50 },
  "minor_allele_freq",
  { data_type => "float", is_nullable => 1 },
  "minor_allele_count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "evidence",
  {
    data_type => "set",
    extra => {
      list => [
        "Multiple_observations",
        "Frequency",
        "HapMap",
        "1000Genomes",
        "Cited",
      ],
    },
    is_nullable => 1,
  },
  "clinical_significance",
  {
    data_type => "set",
    extra => {
      list => [
        "drug-response",
        "histocompatibility",
        "non-pathogenic",
        "other",
        "pathogenic",
        "probable-non-pathogenic",
        "probable-pathogenic'unknown",
        "untested",
      ],
    },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</variation_id>

=back

=cut

__PACKAGE__->set_primary_key("variation_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qXMizdjgUDB3ICfL2NxC0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
