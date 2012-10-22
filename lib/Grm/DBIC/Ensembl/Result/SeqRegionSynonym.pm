package Grm::DBIC::Ensembl::Result::SeqRegionSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::SeqRegionSynonym

=cut

__PACKAGE__->table("seq_region_synonym");

=head1 ACCESSORS

=head2 seq_region_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 synonym

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 external_db_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "seq_region_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "synonym",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "external_db_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("seq_region_synonym_id");
__PACKAGE__->add_unique_constraint("syn_idx", ["synonym"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 12:22:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oEutGNbLoPT5rsbp62gXDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
