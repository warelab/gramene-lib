use utf8;
package Grm::DBIC::Variation::Result::AttribType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::AttribType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<attrib_type>

=cut

__PACKAGE__->table("attrib_type");

=head1 ACCESSORS

=head2 attrib_type_id

  data_type: 'smallint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "attrib_type_id",
  {
    data_type => "smallint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attrib_type_id>

=back

=cut

__PACKAGE__->set_primary_key("attrib_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<code_idx>

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->add_unique_constraint("code_idx", ["code"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oKEmm5oNCF9EUVkiT7Rc2g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
