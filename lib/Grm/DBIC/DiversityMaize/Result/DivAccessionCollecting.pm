package Grm::DBIC::DiversityMaize::Result::DivAccessionCollecting;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityMaize::Result::DivAccessionCollecting

=cut

__PACKAGE__->table("div_accession_collecting");

=head1 ACCESSORS

=head2 div_accession_collecting_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_accession_collecting_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 div_locality_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 collector

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 collnumb

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 collsrc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 collcode

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 col_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_accession_collecting_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_accession_collecting_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "div_locality_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "collector",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "collnumb",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "collsrc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "collcode",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "col_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("div_accession_collecting_id");
__PACKAGE__->add_unique_constraint(
  "div_accession_collecting_acc",
  ["div_accession_collecting_acc"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hx4FKipZQxo4jT5F3OXPFA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
