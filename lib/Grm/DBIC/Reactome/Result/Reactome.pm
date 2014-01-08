use utf8;
package Grm::DBIC::Reactome::Result::Reactome;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Reactome::Result::Reactome

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<reactome>

=cut

__PACKAGE__->table("reactome");

=head1 ACCESSORS

=head2 reactome_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 search_term

  data_type: 'text'
  is_nullable: 1

=head2 pathway_id

  data_type: 'integer'
  is_nullable: 1

=head2 object_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "reactome_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "search_term",
  { data_type => "text", is_nullable => 1 },
  "pathway_id",
  { data_type => "integer", is_nullable => 1 },
  "object_id",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</reactome_id>

=back

=cut

__PACKAGE__->set_primary_key("reactome_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2014-01-06 18:54:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m2ZguDjZBl842vqFRbRcxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
