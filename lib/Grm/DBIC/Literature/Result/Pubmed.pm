package Grm::DBIC::Literature::Result::Pubmed;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::Pubmed

=cut

__PACKAGE__->table("pubmed");

=head1 ACCESSORS

=head2 pubmed_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 source

  data_type: 'text'
  is_nullable: 1

=head2 authors

  data_type: 'text'
  is_nullable: 1

=head2 year

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 volume

  data_type: 'varchar'
  is_nullable: 1
  size: 100

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

=head2 reference_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 abstract

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pubmed_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "source",
  { data_type => "text", is_nullable => 1 },
  "authors",
  { data_type => "text", is_nullable => 1 },
  "year",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "volume",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "start_page",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "end_page",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "language",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "reference_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "abstract",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("pubmed_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0ptMcGWotD6jl4E1HmLF0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
