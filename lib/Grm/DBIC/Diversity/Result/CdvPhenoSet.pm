package Grm::DBIC::Diversity::Result::CdvPhenoSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::CdvPhenoSet

=cut

__PACKAGE__->table("cdv_pheno_set");

=head1 ACCESSORS

=head2 cdv_pheno_set_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_pheno_set_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cdv_g2p_study_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 div_trait_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cdv_pheno_set_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_pheno_set_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cdv_g2p_study_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "div_trait_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("cdv_pheno_set_id");
__PACKAGE__->add_unique_constraint("cdv_pheno_set_acc", ["cdv_pheno_set_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:16:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:itEW5OEdL04pOld1cHEzRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
