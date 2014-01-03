use utf8;
package Grm::DBIC::Ensembl::Result::AssociatedXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AssociatedXref

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<associated_xref>

=cut

__PACKAGE__->table("associated_xref");

=head1 ACCESSORS

=head2 associated_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 object_xref_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 xref_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 source_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 condition_type

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 associated_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 rank

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "associated_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "object_xref_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "xref_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "source_xref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "condition_type",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "associated_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "rank",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</associated_xref_id>

=back

=cut

__PACKAGE__->set_primary_key("associated_xref_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<object_associated_source_type_idx>

=over 4

=item * L</object_xref_id>

=item * L</xref_id>

=item * L</source_xref_id>

=item * L</condition_type>

=item * L</associated_group_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "object_associated_source_type_idx",
  [
    "object_xref_id",
    "xref_id",
    "source_xref_id",
    "condition_type",
    "associated_group_id",
  ],
);

=head1 RELATIONS

=head2 associated_group

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::AssociatedGroup>

=cut

__PACKAGE__->belongs_to(
  "associated_group",
  "Grm::DBIC::Ensembl::Result::AssociatedGroup",
  { associated_group_id => "associated_group_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:96inLkQvWXXd+EghU4Dd4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
