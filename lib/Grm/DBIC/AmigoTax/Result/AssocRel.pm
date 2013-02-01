package Grm::DBIC::AmigoTax::Result::AssocRel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoTax::Result::AssocRel

=cut

__PACKAGE__->table("assoc_rel");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 from_id

  data_type: 'integer'
  is_nullable: 0

=head2 to_id

  data_type: 'integer'
  is_nullable: 0

=head2 relationship_type_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "from_id",
  { data_type => "integer", is_nullable => 0 },
  "to_id",
  { data_type => "integer", is_nullable => 0 },
  "relationship_type_id",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:79gkMlV72czKIBDoyoe+LQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
