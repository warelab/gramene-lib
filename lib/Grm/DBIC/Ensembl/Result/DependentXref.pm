package Grm::DBIC::Ensembl::Result::DependentXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::DependentXref

=cut

__PACKAGE__->table("dependent_xref");

=head1 ACCESSORS

=head2 object_xref_id

  data_type: 'integer'
  is_nullable: 0

=head2 master_xref_id

  data_type: 'integer'
  is_nullable: 0

=head2 dependent_xref_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "object_xref_id",
  { data_type => "integer", is_nullable => 0 },
  "master_xref_id",
  { data_type => "integer", is_nullable => 0 },
  "dependent_xref_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("object_xref_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KMGnNFNBWD0rnu0aj2w3WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
