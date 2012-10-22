package Grm::DBIC::Compara::Result::DomainMember;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Compara::Result::DomainMember

=cut

__PACKAGE__->table("domain_member");

=head1 ACCESSORS

=head2 domain_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 member_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 member_start

  data_type: 'integer'
  is_nullable: 1

=head2 member_end

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "domain_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "member_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "member_start",
  { data_type => "integer", is_nullable => 1 },
  "member_end",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint(
  "member_id",
  ["member_id", "domain_id", "member_start", "member_end"],
);
__PACKAGE__->add_unique_constraint(
  "domain_id",
  ["domain_id", "member_id", "member_start", "member_end"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-22 13:59:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mRMiw1cj4t1bvc3lgTr0IQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
