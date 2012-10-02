package Grm::DBIC::Ensembl::Result::ProteinFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ProteinFeature

=cut

__PACKAGE__->table("protein_feature");

=head1 ACCESSORS

=head2 protein_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 translation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_start

  data_type: 'integer'
  is_nullable: 0

=head2 seq_end

  data_type: 'integer'
  is_nullable: 0

=head2 hit_start

  data_type: 'integer'
  is_nullable: 0

=head2 hit_end

  data_type: 'integer'
  is_nullable: 0

=head2 hit_name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=head2 evalue

  data_type: 'double precision'
  is_nullable: 1

=head2 perc_ident

  data_type: 'float'
  is_nullable: 1

=head2 external_data

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "protein_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "translation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_start",
  { data_type => "integer", is_nullable => 0 },
  "seq_end",
  { data_type => "integer", is_nullable => 0 },
  "hit_start",
  { data_type => "integer", is_nullable => 0 },
  "hit_end",
  { data_type => "integer", is_nullable => 0 },
  "hit_name",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "score",
  { data_type => "double precision", is_nullable => 1 },
  "evalue",
  { data_type => "double precision", is_nullable => 1 },
  "perc_ident",
  { data_type => "float", is_nullable => 1 },
  "external_data",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("protein_feature_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NfCUBb5O9ERPf+wOJHtF6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
