package Grm::DBIC::Ensembl::Result::QtlSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::QtlSynonym

=cut

__PACKAGE__->table("qtl_synonym");

=head1 ACCESSORS

=head2 qtl_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 source_database

  data_type: 'enum'
  extra: {list => ["rat genome database","ratmap"]}
  is_nullable: 0

=head2 source_primary_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "qtl_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "qtl_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "source_database",
  {
    data_type => "enum",
    extra => { list => ["rat genome database", "ratmap"] },
    is_nullable => 0,
  },
  "source_primary_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("qtl_synonym_id");

=head1 RELATIONS

=head2 qtl

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Qtl>

=cut

__PACKAGE__->belongs_to(
  "qtl",
  "Grm::DBIC::Ensembl::Result::Qtl",
  { qtl_id => "qtl_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Og67/TtOWwHtvBFJcJyIKQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
