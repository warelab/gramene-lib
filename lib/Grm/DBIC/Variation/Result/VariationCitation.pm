use utf8;
package Grm::DBIC::Variation::Result::VariationCitation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::VariationCitation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<variation_citation>

=cut

__PACKAGE__->table("variation_citation");

=head1 ACCESSORS

=head2 variation_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "variation_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "publication_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</variation_id>

=item * L</publication_id>

=back

=cut

__PACKAGE__->set_primary_key("variation_id", "publication_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4OQks9AlGV4KYdDRcN9gWA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
