package Grm::DBIC::Diversity::Result::CdvG2pStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvG2pStudy

=cut

__PACKAGE__->table("cdv_g2p_study");

=head1 ACCESSORS

=head2 cdv_g2p_study_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_g2p_study_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_g2p_protocol_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 gwas_significance_value_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 mac_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 maf_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 gwas_position_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 effect_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 bpp_blob

  data_type: 'mediumblob'
  is_nullable: 1

=head2 producer

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 study_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 chromosome

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 gwas_rank_blob

  data_type: 'mediumblob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_g2p_study_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_g2p_study_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_g2p_protocol_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "gwas_significance_value_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "mac_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "maf_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "gwas_position_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "effect_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "bpp_blob",
  { data_type => "mediumblob", is_nullable => 1 },
  "producer",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "study_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "chromosome",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "gwas_rank_blob",
  { data_type => "mediumblob", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_g2p_study_id");
__PACKAGE__->add_unique_constraint("cdv_g2p_study_acc", ["cdv_g2p_study_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RFzFbW6WjCV4oyZW0IS6LA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
