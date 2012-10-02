package Grm::DBIC::Ensembl::Result::ExternalSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ExternalSynonym

=cut

__PACKAGE__->table("external_synonym");

=head1 ACCESSORS

=head2 xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 synonym

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "xref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "synonym",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("xref_id", "synonym");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J4As9KNvlq3fWMmLFreCgQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
