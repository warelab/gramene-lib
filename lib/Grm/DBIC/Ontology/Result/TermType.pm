use utf8;
package Grm::DBIC::Ontology::Result::TermType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::TermType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<term_type>

=cut

__PACKAGE__->table("term_type");

=head1 ACCESSORS

=head2 term_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 term_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 prefix

  data_type: 'char'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "term_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "term_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "prefix",
  { data_type => "char", is_nullable => 1, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_type_id>

=back

=cut

__PACKAGE__->set_primary_key("term_type_id");

=head1 RELATIONS

=head2 terms

Type: has_many

Related object: L<Grm::DBIC::Ontology::Result::Term>

=cut

__PACKAGE__->has_many(
  "terms",
  "Grm::DBIC::Ontology::Result::Term",
  { "foreign.term_type_id" => "self.term_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e0gS3LII3GAEcY4BYpZdnA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
