use utf8;
package Grm::DBIC::Variation::Result::Phenotype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::Phenotype

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<phenotype>

=cut

__PACKAGE__->table("phenotype");

=head1 ACCESSORS

=head2 phenotype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 stable_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "phenotype_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "stable_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</phenotype_id>

=back

=cut

__PACKAGE__->set_primary_key("phenotype_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<desc_idx>

=over 4

=item * L</description>

=back

=cut

__PACKAGE__->add_unique_constraint("desc_idx", ["description"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:APcy3dml3+tpUMaTVgxFmg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
