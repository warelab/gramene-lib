package Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::MiscFeatureMiscSet

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

  data_type: 'integer'
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
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);
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
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 misc_set

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::MiscSet>

=cut

__PACKAGE__->belongs_to(
  "misc_set",
  "Grm::DBIC::Ensembl::Result::MiscSet",
  { misc_set_id => "misc_set_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fnLTfXduitTpck20MVFytQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
