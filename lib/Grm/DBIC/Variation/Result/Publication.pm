use utf8;
package Grm::DBIC::Variation::Result::Publication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Publication

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<publication>

=cut

__PACKAGE__->table("publication");

=head1 ACCESSORS

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 authors

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pmid

  data_type: 'integer'
  is_nullable: 1

=head2 pmcid

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 year

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 doi

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ucsc_id

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "publication_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "authors",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pmid",
  { data_type => "integer", is_nullable => 1 },
  "pmcid",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "year",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "doi",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ucsc_id",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</publication_id>

=back

=cut

__PACKAGE__->set_primary_key("publication_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IB8t4LVkl+9WJi1jsmqIpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
