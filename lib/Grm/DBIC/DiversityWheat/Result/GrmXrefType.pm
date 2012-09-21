package Grm::DBIC::DiversityWheat::Result::GrmXrefType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::GrmXrefType

=cut

__PACKAGE__->table("grm_xref_type");

=head1 ACCESSORS

=head2 xref_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 xref_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 url_template

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "xref_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "xref_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "url_template",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("xref_type_id");
__PACKAGE__->add_unique_constraint("xref_type", ["xref_type"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MEhleWExG4uYtl33uYm47Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
