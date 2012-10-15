package Grm::DBIC::EnsemblCompara::Result::FamilyMember;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::EnsemblCompara::Result::FamilyMember

=cut

__PACKAGE__->table("family_member");

=head1 ACCESSORS

=head2 family_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 member_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cigar_line

  data_type: 'mediumtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "family_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "member_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cigar_line",
  { data_type => "mediumtext", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("family_member_id", ["family_id", "member_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-12 13:35:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8kzGFWvLkBcjysmZJVSNlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
