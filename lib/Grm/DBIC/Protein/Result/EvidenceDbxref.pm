package Grm::DBIC::Protein::Result::EvidenceDbxref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::EvidenceDbxref

=cut

__PACKAGE__->table("evidence_dbxref");

=head1 ACCESSORS

=head2 evidence_dbxref_id

  data_type: 'integer'
  is_nullable: 0

=head2 evidence_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "evidence_dbxref_id",
  { data_type => "integer", is_nullable => 0 },
  "evidence_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "dbxref_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("evidence_dbxref_id");

=head1 RELATIONS

=head2 evidence

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Evidence>

=cut

__PACKAGE__->belongs_to(
  "evidence",
  "Grm::DBIC::Protein::Result::Evidence",
  { evidence_id => "evidence_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::Protein::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gkw1DXs387Gm7DR2y/H0Sg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
