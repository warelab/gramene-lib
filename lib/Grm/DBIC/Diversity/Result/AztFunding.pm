package Grm::DBIC::Diversity::Result::AztFunding;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AztFunding

=cut

__PACKAGE__->table("azt_funding");

=head1 ACCESSORS

=head2 azt_funding_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 funding_agency

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 grant_number

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 grant_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 grant_pi

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 release_rules

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 trait_delay_m

  data_type: 'integer'
  is_nullable: 1

=head2 allele_delay_m

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "azt_funding_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "funding_agency",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "grant_number",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "grant_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "grant_pi",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "release_rules",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "trait_delay_m",
  { data_type => "integer", is_nullable => 1 },
  "allele_delay_m",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("azt_funding_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ycDTi19mYNomsFyvRLgcLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
