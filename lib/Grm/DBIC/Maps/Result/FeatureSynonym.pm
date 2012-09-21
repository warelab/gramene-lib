package Grm::DBIC::Maps::Result::FeatureSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureSynonym

=cut

__PACKAGE__->table("feature_synonym");

=head1 ACCESSORS

=head2 feature_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 synonym_type_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "feature_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "synonym_type_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("feature_synonym_id");
__PACKAGE__->add_unique_constraint(
  "feature_id",
  ["feature_id", "synonym_type_id", "feature_name"],
);

=head1 RELATIONS

=head2 features

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->has_many(
  "features",
  "Grm::DBIC::Maps::Result::Feature",
  { "foreign.display_synonym_id" => "self.feature_synonym_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 synonym_type

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::SynonymType>

=cut

__PACKAGE__->belongs_to(
  "synonym_type",
  "Grm::DBIC::Maps::Result::SynonymType",
  { synonym_type_id => "synonym_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 mappings

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::Mapping>

=cut

__PACKAGE__->has_many(
  "mappings",
  "Grm::DBIC::Maps::Result::Mapping",
  { "foreign.display_synonym_id" => "self.feature_synonym_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S62Kb+MrhJqb6VbCc+OJLg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
