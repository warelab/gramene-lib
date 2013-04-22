package Grm::DBIC::Qtl::Result::QtlAssociationEvidence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::QtlAssociationEvidence

=cut

__PACKAGE__->table("qtl_association_evidence");

=head1 ACCESSORS

=head2 qtl_association_evidence_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_association_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 evidence_code

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 gramene_reference_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "qtl_association_evidence_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "qtl_association_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "evidence_code",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "gramene_reference_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("qtl_association_evidence_id");

=head1 RELATIONS

=head2 qtl_association

Type: belongs_to

Related object: L<Grm::DBIC::Qtl::Result::QtlAssociation>

=cut

__PACKAGE__->belongs_to(
  "qtl_association",
  "Grm::DBIC::Qtl::Result::QtlAssociation",
  { qtl_association_id => "qtl_association_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/0zjJHmECb+8ypP6yjWhKg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
