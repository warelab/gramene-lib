use utf8;
package Grm::DBIC::Ensembl::Result::ExternalSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::ExternalSynonym

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<external_synonym>

=cut

__PACKAGE__->table("external_synonym");

=head1 ACCESSORS

=head2 xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 synonym

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "synonym",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</xref_id>

=item * L</synonym>

=back

=cut

__PACKAGE__->set_primary_key("xref_id", "synonym");

=head1 RELATIONS

=head2 xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Xref>

=cut

__PACKAGE__->belongs_to(
  "xref",
  "Grm::DBIC::Ensembl::Result::Xref",
  { xref_id => "xref_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RkWUs7mmYleI7qP8iHrPvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
