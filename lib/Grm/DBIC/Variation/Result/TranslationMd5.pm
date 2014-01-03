use utf8;
package Grm::DBIC::Variation::Result::TranslationMd5;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::TranslationMd5

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<translation_md5>

=cut

__PACKAGE__->table("translation_md5");

=head1 ACCESSORS

=head2 translation_md5_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 translation_md5

  data_type: 'char'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "translation_md5_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "translation_md5",
  { data_type => "char", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</translation_md5_id>

=back

=cut

__PACKAGE__->set_primary_key("translation_md5_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<md5_idx>

=over 4

=item * L</translation_md5>

=back

=cut

__PACKAGE__->add_unique_constraint("md5_idx", ["translation_md5"]);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NIsinxSS9iVSXWvBQTXd5Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
