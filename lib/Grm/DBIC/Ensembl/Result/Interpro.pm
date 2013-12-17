use utf8;
package Grm::DBIC::Ensembl::Result::Interpro;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Interpro

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<interpro>

=cut

__PACKAGE__->table("interpro");

=head1 ACCESSORS

=head2 interpro_ac

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 id

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=cut

__PACKAGE__->add_columns(
  "interpro_ac",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "id",
  { data_type => "varchar", is_nullable => 0, size => 40 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<accession_idx>

=over 4

=item * L</interpro_ac>

=item * L</id>

=back

=cut

__PACKAGE__->add_unique_constraint("accession_idx", ["interpro_ac", "id"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U2G8BWHnLbRh0RbdndbAsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
