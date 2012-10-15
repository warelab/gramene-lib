package Grm::DBIC::EnsemblCompara::Result::SequenceCd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::SequenceCd

=cut

__PACKAGE__->table("sequence_cds");

=head1 ACCESSORS

=head2 sequence_cds_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 member_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 length

  data_type: 'integer'
  is_nullable: 0

=head2 sequence_cds

  data_type: 'longtext'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sequence_cds_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "member_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "length",
  { data_type => "integer", is_nullable => 0 },
  "sequence_cds",
  { data_type => "longtext", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("sequence_cds_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/evwlBwMerDPLiAwoWTE0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
