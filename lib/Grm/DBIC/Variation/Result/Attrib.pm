use utf8;
package Grm::DBIC::Variation::Result::Attrib;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Attrib

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<attrib>

=cut

__PACKAGE__->table("attrib");

=head1 ACCESSORS

=head2 attrib_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 attrib_type_id

  data_type: 'smallint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "attrib_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "attrib_type_id",
  {
    data_type => "smallint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "value",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attrib_id>

=back

=cut

__PACKAGE__->set_primary_key("attrib_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type_val_idx>

=over 4

=item * L</attrib_type_id>

=item * L</value>

=back

=cut

__PACKAGE__->add_unique_constraint("type_val_idx", ["attrib_type_id", "value"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6zzZ0lM3hGj/i/C5W/zkig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
