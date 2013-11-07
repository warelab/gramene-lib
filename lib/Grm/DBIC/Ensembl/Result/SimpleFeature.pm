use utf8;
package Grm::DBIC::Ensembl::Result::SimpleFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::SimpleFeature

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<simple_feature>

=cut

__PACKAGE__->table("simple_feature");

=head1 ACCESSORS

=head2 simple_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_strand

  data_type: 'tinyint'
  is_nullable: 0

=head2 display_label

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 score

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "simple_feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_strand",
  { data_type => "tinyint", is_nullable => 0 },
  "display_label",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "score",
  { data_type => "double precision", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</simple_feature_id>

=back

=cut

__PACKAGE__->set_primary_key("simple_feature_id");

=head1 RELATIONS

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HXqFkA92vpqUJcJlhDJ5tA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
