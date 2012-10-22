package Grm::DBIC::Ensembl::Result::UnmappedReason;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::UnmappedReason

=cut

__PACKAGE__->table("unmapped_reason");

=head1 ACCESSORS

=head2 unmapped_reason_id

  data_type: 'integer'
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
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "summary_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "full_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xnd+dj9z1bFaX+IOX7GF9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
