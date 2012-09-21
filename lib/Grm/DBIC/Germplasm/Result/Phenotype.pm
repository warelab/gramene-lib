package Grm::DBIC::Germplasm::Result::Phenotype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Germplasm::Result::Phenotype

=cut

__PACKAGE__->table("phenotype");

=head1 ACCESSORS

=head2 phenotype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 germplasm_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 to_accession

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 phenotype_value

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 literature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "phenotype_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "germplasm_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "to_accession",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "phenotype_value",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "literature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("phenotype_id");

=head1 RELATIONS

=head2 germplasm

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::Germplasm>

=cut

__PACKAGE__->belongs_to(
  "germplasm",
  "Grm::DBIC::Germplasm::Result::Germplasm",
  { germplasm_id => "germplasm_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:02:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AJLiWZ9i9+ujXAzxdfmedQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
