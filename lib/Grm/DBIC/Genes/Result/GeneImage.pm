package Grm::DBIC::Genes::Result::GeneImage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Genes::Result::GeneImage

=cut

__PACKAGE__->table("gene_image");

=head1 ACCESSORS

=head2 image_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 file_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 image_comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "image_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "file_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "image_comment",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("image_id");
__PACKAGE__->add_unique_constraint("file_name", ["file_name"]);

=head1 RELATIONS

=head2 gene_object_to_images

Type: has_many

Related object: L<Grm::DBIC::Genes::Result::GeneObjectToImage>

=cut

__PACKAGE__->has_many(
  "gene_object_to_images",
  "Grm::DBIC::Genes::Result::GeneObjectToImage",
  { "foreign.image_id" => "self.image_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-26 11:34:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mky8jvbvf20GrpvK9G5kVQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
