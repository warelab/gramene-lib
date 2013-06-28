package Grm::DBIC::Genes::Result::GeneDbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneDbxref

=cut

__PACKAGE__->table("gene_dbxref");

=head1 ACCESSORS

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 dbxref_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 url

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "dbxref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "dbxref_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "url",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("dbxref_id");
__PACKAGE__->add_unique_constraint("dbxref_name", ["dbxref_name"]);

=head1 RELATIONS

=head2 gene_dbxrefs_to_object

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneDbxrefToObject>

=cut

__PACKAGE__->has_many(
  "gene_dbxrefs_to_object",
  "Grm::DBIC::Genes::Result::GeneDbxrefToObject",
  { "foreign.dbxref_id" => "self.dbxref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IS2PAYM7CsW6qPKW5H9gHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
