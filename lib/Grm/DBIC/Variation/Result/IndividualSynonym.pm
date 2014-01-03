use utf8;
package Grm::DBIC::Variation::Result::IndividualSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::IndividualSynonym

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<individual_synonym>

=cut

__PACKAGE__->table("individual_synonym");

=head1 ACCESSORS

=head2 synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 individual_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 source_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "individual_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "source_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</synonym_id>

=back

=cut

__PACKAGE__->set_primary_key("synonym_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0RMX+NJgmOyQqvm9Mt/9NQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
