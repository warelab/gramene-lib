package Grm::DBIC::Diversity::Result::StsSubmission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::StsSubmission

=cut

__PACKAGE__->table("sts_submission");

=head1 ACCESSORS

=head2 db_sts_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 user_id

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 genbank_accn

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 pzb_num

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 line

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "db_sts_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "user_id",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "genbank_accn",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "pzb_num",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "line",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("db_sts_id");
__PACKAGE__->add_unique_constraint("genbank_accn", ["genbank_accn"]);
__PACKAGE__->add_unique_constraint("user_id", ["user_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dMHLkp2mg7+3NLBztzgg/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
