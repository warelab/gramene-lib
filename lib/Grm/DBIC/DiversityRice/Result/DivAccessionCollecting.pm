package Grm::DBIC::DiversityRice::Result::DivAccessionCollecting;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityRice::Result::DivAccessionCollecting

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
  is_foreign_key: 1
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
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
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

=head1 RELATIONS

=head2 div_locality

Type: belongs_to

Related object: L<Grm::DBIC::DiversityRice::Result::DivLocality>

=cut

__PACKAGE__->belongs_to(
  "div_locality",
  "Grm::DBIC::DiversityRice::Result::DivLocality",
  { div_locality_id => "div_locality_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 div_passports

Type: has_many

Related object: L<Grm::DBIC::DiversityRice::Result::DivPassport>

=cut

__PACKAGE__->has_many(
  "div_passports",
  "Grm::DBIC::DiversityRice::Result::DivPassport",
  {
    "foreign.div_accession_collecting_id" => "self.div_accession_collecting_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 18:50:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gp8fQqx3qflSP+4qD7K+fQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
