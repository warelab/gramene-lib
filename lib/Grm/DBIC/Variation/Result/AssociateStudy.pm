use utf8;
package Grm::DBIC::Variation::Result::AssociateStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::AssociateStudy

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<associate_study>

=cut

__PACKAGE__->table("associate_study");

=head1 ACCESSORS

=head2 study1_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 study2_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "study1_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "study2_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</study1_id>

=item * L</study2_id>

=back

=cut

__PACKAGE__->set_primary_key("study1_id", "study2_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eBXjJr0oCbhIuas2bDHm6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
