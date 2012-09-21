package Grm::DBIC::DiversityWheat::Result::DivGeneration;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversityWheat::Result::DivGeneration

=cut

__PACKAGE__->table("div_generation");

=head1 ACCESSORS

=head2 div_generation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_generation_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 icis_id

  data_type: 'text'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=head2 selfing_number

  data_type: 'integer'
  is_nullable: 1

=head2 sibbing_number

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "div_generation_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_generation_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "icis_id",
  { data_type => "text", is_nullable => 1 },
  "comments",
  { data_type => "text", is_nullable => 1 },
  "selfing_number",
  { data_type => "integer", is_nullable => 1 },
  "sibbing_number",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("div_generation_id");

=head1 RELATIONS

=head2 div_stocks

Type: has_many

Related object: L<Grm::DBIC::DiversityWheat::Result::DivStock>

=cut

__PACKAGE__->has_many(
  "div_stocks",
  "Grm::DBIC::DiversityWheat::Result::DivStock",
  { "foreign.div_generation_id" => "self.div_generation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JgJEg3LCkRKjtFsPIBKH4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
