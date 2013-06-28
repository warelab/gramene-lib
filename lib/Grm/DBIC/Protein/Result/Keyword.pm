package Grm::DBIC::Protein::Result::Keyword;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Keyword

=cut

__PACKAGE__->table("keyword");

=head1 ACCESSORS

=head2 keyword_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 keyword

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "keyword_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "keyword",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("keyword_id");

=head1 RELATIONS

=head2 gene_product_to_keywords

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductToKeyword>

=cut

__PACKAGE__->has_many(
  "gene_product_to_keywords",
  "Grm::DBIC::Protein::Result::GeneProductToKeyword",
  { "foreign.keyword_id" => "self.keyword_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3DRKFulpsJC27042wVqZrw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
