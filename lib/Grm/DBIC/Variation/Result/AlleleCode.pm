use utf8;
package Grm::DBIC::Variation::Result::AlleleCode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::AlleleCode

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<allele_code>

=cut

__PACKAGE__->table("allele_code");

=head1 ACCESSORS

=head2 allele_code_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 allele

  data_type: 'varchar'
  is_nullable: 1
  size: 60000

=cut

__PACKAGE__->add_columns(
  "allele_code_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "allele",
  { data_type => "varchar", is_nullable => 1, size => 60000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</allele_code_id>

=back

=cut

__PACKAGE__->set_primary_key("allele_code_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<allele_idx>

=over 4

=item * L</allele>

=back

=cut

__PACKAGE__->add_unique_constraint("allele_idx", ["allele"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:efHF/4KFHhDsOcWJf4r66A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
