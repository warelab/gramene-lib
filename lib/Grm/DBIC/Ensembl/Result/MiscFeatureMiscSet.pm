use utf8;
package Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<misc_feature_misc_set>

=cut

__PACKAGE__->table("misc_feature_misc_set");

=head1 ACCESSORS

=head2 misc_feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 misc_set_id

  data_type: 'smallint'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "misc_feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "misc_set_id",
  {
    data_type => "smallint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</misc_feature_id>

=item * L</misc_set_id>

=back

=cut

__PACKAGE__->set_primary_key("misc_feature_id", "misc_set_id");

=head1 RELATIONS

=head2 misc_feature

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MiscFeature>

=cut

__PACKAGE__->belongs_to(
  "misc_feature",
  "Grm::DBIC::Ensembl::Result::MiscFeature",
  { misc_feature_id => "misc_feature_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 misc_set

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MiscSet>

=cut

__PACKAGE__->belongs_to(
  "misc_set",
  "Grm::DBIC::Ensembl::Result::MiscSet",
  { misc_set_id => "misc_set_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FMUOcpAfm3JkYaBUMmSrUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
