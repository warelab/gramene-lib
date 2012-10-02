package Grm::DBIC::Literature::Result::Reference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::Reference

=cut

__PACKAGE__->table("reference");

=head1 ACCESSORS

=head2 reference_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 volume

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 year

  data_type: 'integer'
  is_nullable: 1

=head2 start_page

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 end_page

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 language

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 comment

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 reference_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url_label

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 abstract

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "reference_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "source_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "title",
  { data_type => "text", is_nullable => 0 },
  "volume",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "year",
  { data_type => "integer", is_nullable => 1 },
  "start_page",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "end_page",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "language",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "comment",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "reference_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url_label",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "abstract",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("reference_id");

=head1 RELATIONS

=head2 authors

Type: has_many

Related object: L<Grm::DBIC::Literature::Result::Author>

=cut

__PACKAGE__->has_many(
  "authors",
  "Grm::DBIC::Literature::Result::Author",
  { "foreign.reference_id" => "self.reference_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 source

Type: belongs_to

Related object: L<Grm::DBIC::Literature::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "source",
  "Grm::DBIC::Literature::Result::Source",
  { source_id => "source_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oGMG/kqvKLhy/oxWFz4C6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
