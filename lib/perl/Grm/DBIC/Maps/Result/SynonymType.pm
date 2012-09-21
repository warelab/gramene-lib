package Grm::DBIC::Maps::Result::SynonymType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::SynonymType

=cut

__PACKAGE__->table("synonym_type");

=head1 ACCESSORS

=head2 synonym_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 synonym_type

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 url_template

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 preprocess_name_for_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 validation

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "synonym_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "synonym_type",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "url_template",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "preprocess_name_for_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "validation",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("synonym_type_id");
__PACKAGE__->add_unique_constraint("synonym_type", ["synonym_type"]);

=head1 RELATIONS

=head2 feature_synonyms

Type: has_many

Related object: L<Grm::DBIC::Maps::Result::FeatureSynonym>

=cut

__PACKAGE__->has_many(
  "feature_synonyms",
  "Grm::DBIC::Maps::Result::FeatureSynonym",
  { "foreign.synonym_type_id" => "self.synonym_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UUu30VbU858OcAXLoIXUgw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
