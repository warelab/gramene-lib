use utf8;
package Grm::DBIC::Variation::Result::Population;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Population

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<population>

=cut

__PACKAGE__->table("population");

=head1 ACCESSORS

=head2 population_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 size

  data_type: 'integer'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 collection

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 freqs_from_gts

  data_type: 'tinyint'
  is_nullable: 1

=head2 display

  data_type: 'enum'
  default_value: 'UNDISPLAYABLE'
  extra: {list => ["LD","MARTDISPLAYABLE","UNDISPLAYABLE"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "population_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "size",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "collection",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "freqs_from_gts",
  { data_type => "tinyint", is_nullable => 1 },
  "display",
  {
    data_type => "enum",
    default_value => "UNDISPLAYABLE",
    extra => { list => ["LD", "MARTDISPLAYABLE", "UNDISPLAYABLE"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</population_id>

=back

=cut

__PACKAGE__->set_primary_key("population_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5C+XDwl+d6cgH7ka5QKyqA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
