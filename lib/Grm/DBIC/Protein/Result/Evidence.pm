package Grm::DBIC::Protein::Result::Evidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Protein::Result::Evidence

=cut

__PACKAGE__->table("evidence");

=head1 ACCESSORS

=head2 evidence_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 evidence_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 8

=head2 association_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 dbxref_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "evidence_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "evidence_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 8 },
  "association_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "dbxref_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "seq_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("evidence_id");
__PACKAGE__->add_unique_constraint(
  "association_id_2",
  ["association_id", "evidence_code", "dbxref_id"],
);

=head1 RELATIONS

=head2 association

Type: belongs_to

Related object: L<Grm::DBIC::Protein::Result::Association>

=cut

__PACKAGE__->belongs_to(
  "association",
  "Grm::DBIC::Protein::Result::Association",
  { association_id => "association_id" },
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

=head2 evidence_dbxrefs

Type: has_many

Related object: L<Grm::DBIC::Protein::Result::EvidenceDbxref>

=cut

__PACKAGE__->has_many(
  "evidence_dbxrefs",
  "Grm::DBIC::Protein::Result::EvidenceDbxref",
  { "foreign.evidence_id" => "self.evidence_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-06-28 10:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YS/yefnjPs3R1ZM+Zmv3qQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
