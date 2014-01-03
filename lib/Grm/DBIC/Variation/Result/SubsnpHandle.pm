use utf8;
package Grm::DBIC::Variation::Result::SubsnpHandle;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::SubsnpHandle

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<subsnp_handle>

=cut

__PACKAGE__->table("subsnp_handle");

=head1 ACCESSORS

=head2 subsnp_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 handle

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "subsnp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "handle",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</subsnp_id>

=back

=cut

__PACKAGE__->set_primary_key("subsnp_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tq2s2IDpXhNeLnJi0cwRVg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
