package Grm::DBIC::Diversity::Result::CdvGenoSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvGenoSet

=cut

__PACKAGE__->table("cdv_geno_set");

=head1 ACCESSORS

=head2 cdv_geno_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_geno_set_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_g2p_study_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 div_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cdv_geno_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_geno_set_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_g2p_study_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "div_allele_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("cdv_geno_set_id");
__PACKAGE__->add_unique_constraint("cdv_geno_set_acc", ["cdv_geno_set_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:62dcHBeU3012KpGAGHo4qA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
