use utf8;
package Grm::DBIC::Variation::Result::Individual;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Individual

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<individual>

=cut

__PACKAGE__->table("individual");

=head1 ACCESSORS

=head2 individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 gender

  data_type: 'enum'
  default_value: 'Unknown'
  extra: {list => ["Male","Female","Unknown"]}
  is_nullable: 0

=head2 father_individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mother_individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 individual_type_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 display

  data_type: 'enum'
  default_value: 'UNDISPLAYABLE'
  extra: {list => ["REFERENCE","DEFAULT","DISPLAYABLE","UNDISPLAYABLE","LD","MARTDISPLAYABLE"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "individual_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "gender",
  {
    data_type => "enum",
    default_value => "Unknown",
    extra => { list => ["Male", "Female", "Unknown"] },
    is_nullable => 0,
  },
  "father_individual_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "mother_individual_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "individual_type_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "display",
  {
    data_type => "enum",
    default_value => "UNDISPLAYABLE",
    extra => {
      list => [
        "REFERENCE",
        "DEFAULT",
        "DISPLAYABLE",
        "UNDISPLAYABLE",
        "LD",
        "MARTDISPLAYABLE",
      ],
    },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</individual_id>

=back

=cut

__PACKAGE__->set_primary_key("individual_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nDvVJXAehkWhM2fHbCV4sA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
