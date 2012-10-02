package Grm::DBIC::Ensembl::Result::Marker;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Marker

=cut

__PACKAGE__->table("marker");

=head1 ACCESSORS

=head2 marker_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 display_marker_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 left_primer

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 right_primer

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 min_primer_dist

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 max_primer_dist

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 priority

  data_type: 'integer'
  is_nullable: 1

=head2 type

  data_type: 'enum'
  extra: {list => ["est","microsatellite"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "marker_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "display_marker_synonym_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "left_primer",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "right_primer",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "min_primer_dist",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "max_primer_dist",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "priority",
  { data_type => "integer", is_nullable => 1 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["est", "microsatellite"] },
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("marker_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zjk9SQFhTJ39qsQjxuiNHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
