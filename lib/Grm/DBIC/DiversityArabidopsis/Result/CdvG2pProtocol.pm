package Grm::DBIC::DiversityArabidopsis::Result::CdvG2pProtocol;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityArabidopsis::Result::CdvG2pProtocol

=cut

__PACKAGE__->table("cdv_g2p_protocol");

=head1 ACCESSORS

=head2 cdv_g2p_protocol_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_g2p_protocol_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 analysis_method

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cdv_g2p_protocol_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cdv_g2p_protocol_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "analysis_method",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("cdv_g2p_protocol_id");
__PACKAGE__->add_unique_constraint("cdv_g2p_protocol_acc", ["cdv_g2p_protocol_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eQeEwJv+AdjIPJaivY87jA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
