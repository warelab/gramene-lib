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

=head2 interpro_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

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
  "interpro_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "interpro_ac",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "id",
  { data_type => "varchar", is_nullable => 0, size => 40 },
);
__PACKAGE__->set_primary_key("interpro_id");
__PACKAGE__->add_unique_constraint("accession_idx", ["interpro_ac", "id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:41:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RvQpjvACF2IKTs+GifG//w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
