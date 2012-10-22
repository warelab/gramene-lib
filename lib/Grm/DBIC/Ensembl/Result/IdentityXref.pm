package Grm::DBIC::Ensembl::Result::IdentityXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::IdentityXref

=cut

__PACKAGE__->table("identity_xref");

=head1 ACCESSORS

=head2 object_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 xref_identity

  data_type: 'integer'
  is_nullable: 1

=head2 ensembl_identity

  data_type: 'integer'
  is_nullable: 1

=head2 xref_start

  data_type: 'integer'
  is_nullable: 1

=head2 xref_end

  data_type: 'integer'
  is_nullable: 1

=head2 ensembl_start

  data_type: 'integer'
  is_nullable: 1

=head2 ensembl_end

  data_type: 'integer'
  is_nullable: 1

=head2 cigar_line

  data_type: 'text'
  is_nullable: 1

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=head2 evalue

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "object_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "xref_identity",
  { data_type => "integer", is_nullable => 1 },
  "ensembl_identity",
  { data_type => "integer", is_nullable => 1 },
  "xref_start",
  { data_type => "integer", is_nullable => 1 },
  "xref_end",
  { data_type => "integer", is_nullable => 1 },
  "ensembl_start",
  { data_type => "integer", is_nullable => 1 },
  "ensembl_end",
  { data_type => "integer", is_nullable => 1 },
  "cigar_line",
  { data_type => "text", is_nullable => 1 },
  "score",
  { data_type => "double precision", is_nullable => 1 },
  "evalue",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("object_xref_id");

=head1 RELATIONS

=head2 object_xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::ObjectXref>

=cut

__PACKAGE__->belongs_to(
  "object_xref",
  "Grm::DBIC::Ensembl::Result::ObjectXref",
  { object_xref_id => "object_xref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:46ly8cDEtQNy6YAO8MTDDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
