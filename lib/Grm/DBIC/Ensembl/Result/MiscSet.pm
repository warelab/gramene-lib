use utf8;
package Grm::DBIC::Ensembl::Result::MiscSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MiscSet

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<misc_set>

=cut

__PACKAGE__->table("misc_set");

=head1 ACCESSORS

=head2 misc_set_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 25

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 0

=head2 max_length

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "misc_set_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 25 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 0 },
  "max_length",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</misc_set_id>

=back

=cut

__PACKAGE__->set_primary_key("misc_set_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<code_idx>

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->add_unique_constraint("code_idx", ["code"]);

=head1 RELATIONS

=head2 misc_feature_misc_sets

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet>

=cut

__PACKAGE__->has_many(
  "misc_feature_misc_sets",
  "Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet",
  { "foreign.misc_set_id" => "self.misc_set_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 misc_features

Type: many_to_many

Composing rels: L</misc_feature_misc_sets> -> misc_feature

=cut

__PACKAGE__->many_to_many("misc_features", "misc_feature_misc_sets", "misc_feature");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0RPu9QZIM+w8htian89eeQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
