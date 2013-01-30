package Grm::DBIC::OntologyPo::Result::Evidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::OntologyPo::Result::Evidence

=cut

__PACKAGE__->table("evidence");

=head1 ACCESSORS

=head2 evidence_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 evidence_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 8

=head2 association_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 object_class

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

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
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "evidence_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 8 },
  "association_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "object_class",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
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

=head1 RELATIONS

=head2 dbxref

Type: belongs_to

Related object: L<Grm::DBIC::OntologyPo::Result::Dbxref>

=cut

__PACKAGE__->belongs_to(
  "dbxref",
  "Grm::DBIC::OntologyPo::Result::Dbxref",
  { dbxref_id => "dbxref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-01-18 17:37:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KvZOfOZ7K7igpH0Bi3tLeQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
