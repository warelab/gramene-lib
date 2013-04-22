package Grm::DBIC::Qtl::Result::QtlAssociation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Qtl::Result::QtlAssociation

=cut

__PACKAGE__->table("qtl_association");

=head1 ACCESSORS

=head2 qtl_association_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 qtl_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 association_type

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 term_accession

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 term_description

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "qtl_association_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "qtl_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "association_type",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "term_accession",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "term_description",
  { data_type => "varchar", is_nullable => 1, size => 128 },
);
__PACKAGE__->set_primary_key("qtl_association_id");
__PACKAGE__->add_unique_constraint("qtl_id", ["qtl_id", "term_accession"]);

=head1 RELATIONS

=head2 qtl

Type: belongs_to

Related object: L<Grm::DBIC::Qtl::Result::Qtl>

=cut

__PACKAGE__->belongs_to(
  "qtl",
  "Grm::DBIC::Qtl::Result::Qtl",
  { qtl_id => "qtl_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 qtl_association_evidences

Type: has_many

Related object: L<Grm::DBIC::Qtl::Result::QtlAssociationEvidence>

=cut

__PACKAGE__->has_many(
  "qtl_association_evidences",
  "Grm::DBIC::Qtl::Result::QtlAssociationEvidence",
  { "foreign.qtl_association_id" => "self.qtl_association_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-04-11 17:53:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0vP/6VyehMPnQ8mQa88EUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
