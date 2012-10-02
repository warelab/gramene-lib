package Grm::DBIC::Literature::Result::Contributor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::Contributor

=cut

__PACKAGE__->table("contributor");

=head1 ACCESSORS

=head2 contributor_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 contributor_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 contributor_email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 contributor_organization

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 contributor_address

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 contributor_phone

  data_type: 'integer'
  is_nullable: 1

=head2 contributor_fax

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "contributor_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "contributor_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "contributor_email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "contributor_organization",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "contributor_address",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "contributor_phone",
  { data_type => "integer", is_nullable => 1 },
  "contributor_fax",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("contributor_id");

=head1 RELATIONS

=head2 authors

Type: has_many

Related object: L<Grm::DBIC::Literature::Result::Author>

=cut

__PACKAGE__->has_many(
  "authors",
  "Grm::DBIC::Literature::Result::Author",
  { "foreign.contributor_id" => "self.contributor_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wS3NAztbA0bLmHEsmKWWRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
