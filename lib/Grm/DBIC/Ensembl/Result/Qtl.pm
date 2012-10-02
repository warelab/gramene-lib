package Grm::DBIC::Ensembl::Result::Qtl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Qtl

=cut

__PACKAGE__->table("qtl");

=head1 ACCESSORS

=head2 qtl_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 trait

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 lod_score

  data_type: 'float'
  is_nullable: 1

=head2 flank_marker_id_1

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 flank_marker_id_2

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 peak_marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "qtl_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "trait",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "lod_score",
  { data_type => "float", is_nullable => 1 },
  "flank_marker_id_1",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "flank_marker_id_2",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "peak_marker_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("qtl_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1fHUBcR+35FsQjBf/ILr2Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
