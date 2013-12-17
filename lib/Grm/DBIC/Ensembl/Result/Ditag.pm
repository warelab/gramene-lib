use utf8;
package Grm::DBIC::Ensembl::Result::Ditag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Ditag

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<ditag>

=cut

__PACKAGE__->table("ditag");

=head1 ACCESSORS

=head2 ditag_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 tag_count

  data_type: 'smallint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sequence

  accessor: undef
  data_type: 'tinytext'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ditag_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "tag_count",
  {
    data_type => "smallint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "sequence",
  { accessor => undef, data_type => "tinytext", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ditag_id>

=back

=cut

__PACKAGE__->set_primary_key("ditag_id");

=head1 RELATIONS

=head2 ditag_features

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::DitagFeature>

=cut

__PACKAGE__->has_many(
  "ditag_features",
  "Grm::DBIC::Ensembl::Result::DitagFeature",
  { "foreign.ditag_id" => "self.ditag_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fBqtQ3198zsueFOZ4RVLvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
