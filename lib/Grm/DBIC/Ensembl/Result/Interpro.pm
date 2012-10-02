package Grm::DBIC::Ensembl::Result::Interpro;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Interpro

=cut

__PACKAGE__->table("interpro");

=head1 ACCESSORS

=head2 interpro_ac

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 id

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=cut

__PACKAGE__->add_columns(
  "interpro_ac",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "id",
  { data_type => "varchar", is_nullable => 0, size => 40 },
);
__PACKAGE__->add_unique_constraint("accession_idx", ["interpro_ac", "id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Si0uV2DlDiyuOqGxR5fCTA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
