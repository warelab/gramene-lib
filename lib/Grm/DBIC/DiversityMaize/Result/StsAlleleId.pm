package Grm::DBIC::DiversityMaize::Result::StsAlleleId;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::StsAlleleId

=cut

__PACKAGE__->table("sts_allele_id");

=head1 ACCESSORS

=head2 pzb_line

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 div_allele_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pzb_line",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "div_allele_id",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1vKFdr+Jt5mIsUbHHvD+Ww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
