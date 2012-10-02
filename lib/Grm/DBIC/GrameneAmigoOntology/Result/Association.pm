package Grm::DBIC::GrameneAmigoOntology::Result::Association;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::GrameneAmigoOntology::Result::Association

=cut

__PACKAGE__->table("association");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 gene_product_id

  data_type: 'integer'
  is_nullable: 0

=head2 is_not

  data_type: 'integer'
  is_nullable: 1

=head2 role_group

  data_type: 'integer'
  is_nullable: 1

=head2 assocdate

  data_type: 'integer'
  is_nullable: 1

=head2 source_db_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "gene_product_id",
  { data_type => "integer", is_nullable => 0 },
  "is_not",
  { data_type => "integer", is_nullable => 1 },
  "role_group",
  { data_type => "integer", is_nullable => 1 },
  "assocdate",
  { data_type => "integer", is_nullable => 1 },
  "source_db_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xzMzQU26CRM7D69KUo0o2Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
