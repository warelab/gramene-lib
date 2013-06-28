package Grm::DBIC::Protein::Result::Objectxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Objectxref

=cut

__PACKAGE__->table("objectxref");

=head1 ACCESSORS

=head2 objectxref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 60

=head2 row_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "objectxref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "table_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 60 },
  "row_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dbxref_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);
__PACKAGE__->set_primary_key("objectxref_id");
__PACKAGE__->add_unique_constraint("table_name", ["table_name", "row_id", "dbxref_id"]);

=head1 RELATIONS

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::Protein::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QohfaXdAvpEBzp1yb1fMlw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
