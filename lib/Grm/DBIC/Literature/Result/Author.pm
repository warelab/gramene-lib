package Grm::DBIC::Literature::Result::Author;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::Author

=cut

__PACKAGE__->table("author");

=head1 ACCESSORS

=head2 author_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 contributor_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 reference_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 authorship_position

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "author_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "contributor_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "reference_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "authorship_position",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("author_id");
__PACKAGE__->add_unique_constraint("contributor_id_2", ["contributor_id", "reference_id"]);

=head1 RELATIONS

=head2 contributor

Type: belongs_to

Related object: L<Grm::DBIC::Literature::Result::Contributor>

=cut

__PACKAGE__->belongs_to(
  "contributor",
  "Grm::DBIC::Literature::Result::Contributor",
  { contributor_id => "contributor_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 reference

Type: belongs_to

Related object: L<Grm::DBIC::Literature::Result::Reference>

=cut

__PACKAGE__->belongs_to(
  "reference",
  "Grm::DBIC::Literature::Result::Reference",
  { reference_id => "reference_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ffj52Rd0LdZBwavUnOrW1g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
