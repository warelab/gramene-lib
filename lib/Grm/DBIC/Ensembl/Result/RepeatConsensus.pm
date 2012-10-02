package Grm::DBIC::Ensembl::Result::RepeatConsensus;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::RepeatConsensus

=cut

__PACKAGE__->table("repeat_consensus");

=head1 ACCESSORS

=head2 repeat_consensus_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 repeat_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 repeat_class

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 repeat_type

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 repeat_consensus

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "repeat_consensus_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "repeat_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "repeat_class",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "repeat_type",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "repeat_consensus",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("repeat_consensus_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P2XVP/ZPwGZgVxzvsqB+Uw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
