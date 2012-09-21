package Grm::DBIC::DiversityMaize::Result::AztPrivateAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::AztPrivateAllele

=cut

__PACKAGE__->table("azt_private_allele");

=head1 ACCESSORS

=head2 azt_private_allele_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 div_allele_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "azt_private_allele_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "div_allele_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("azt_private_allele_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5yc8dJfkad68zNNS+H6g3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
