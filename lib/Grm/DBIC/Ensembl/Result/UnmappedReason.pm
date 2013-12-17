use utf8;
package Grm::DBIC::Ensembl::Result::UnmappedReason;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::UnmappedReason

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<unmapped_reason>

=cut

__PACKAGE__->table("unmapped_reason");

=head1 ACCESSORS

=head2 unmapped_reason_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 summary_description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 full_description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "unmapped_reason_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "summary_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "full_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unmapped_reason_id>

=back

=cut

__PACKAGE__->set_primary_key("unmapped_reason_id");

=head1 RELATIONS

=head2 unmapped_objects

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::UnmappedObject>

=cut

__PACKAGE__->has_many(
  "unmapped_objects",
  "Grm::DBIC::Ensembl::Result::UnmappedObject",
  { "foreign.unmapped_reason_id" => "self.unmapped_reason_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZRFIgIErtKf/FnSGZ8qGZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
