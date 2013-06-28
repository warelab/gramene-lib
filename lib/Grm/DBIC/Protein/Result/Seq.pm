package Grm::DBIC::Protein::Result::Seq;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Seq

=cut

__PACKAGE__->table("seq");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 display_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 seq

  data_type: 'text'
  is_nullable: 0

=head2 seq_len

  data_type: 'integer'
  is_nullable: 1

=head2 md5checksum

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 moltype

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 timestamp

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "display_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "seq",
  { data_type => "text", is_nullable => 0 },
  "seq_len",
  { data_type => "integer", is_nullable => 1 },
  "md5checksum",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "moltype",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "timestamp",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("display_id", ["display_id"]);

=head1 RELATIONS

=head2 gene_product_seqs

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::GeneProductSeq>

=cut

__PACKAGE__->has_many(
  "gene_product_seqs",
  "Grm::DBIC::Protein::Result::GeneProductSeq",
  { "foreign.seq_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V/dP28vTE0ltG0CH4bi1vA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
