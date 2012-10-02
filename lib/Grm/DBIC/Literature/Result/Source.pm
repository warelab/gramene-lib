package Grm::DBIC::Literature::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::Source

=cut

__PACKAGE__->table("source");

=head1 ACCESSORS

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 source_name

  accessor: undef
  data_type: 'text'
  is_nullable: 0

=head2 issn

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 source_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url_label

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "source_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "source_name",
  { accessor => undef, data_type => "text", is_nullable => 0 },
  "issn",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "source_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url_label",
  { data_type => "varchar", is_nullable => 1, size => 40 },
);
__PACKAGE__->set_primary_key("source_id");

=head1 RELATIONS

=head2 references

Type: has_many

Related object: L<Grm::DBIC::Literature::Result::Reference>

=cut

__PACKAGE__->has_many(
  "references",
  "Grm::DBIC::Literature::Result::Reference",
  { "foreign.source_id" => "self.source_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 source_synonyms

Type: has_many

Related object: L<Grm::DBIC::Literature::Result::SourceSynonym>

=cut

__PACKAGE__->has_many(
  "source_synonyms",
  "Grm::DBIC::Literature::Result::SourceSynonym",
  { "foreign.source_id" => "self.source_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sQhppXvnbKPeBR5lJNu4cQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
