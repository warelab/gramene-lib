package Grm::DBIC::Ensembl::Result::Ditag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Ditag

=cut

__PACKAGE__->table("ditag");

=head1 ACCESSORS

=head2 ditag_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 tag_count

  data_type: 'smallint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sequence

  accessor: undef
  data_type: 'tinytext'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ditag_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "tag_count",
  {
    data_type => "smallint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "sequence",
  { accessor => undef, data_type => "tinytext", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("ditag_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GXSwokyAfIYWN9kay/CszQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
