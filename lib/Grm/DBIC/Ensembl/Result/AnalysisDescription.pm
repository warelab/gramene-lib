use utf8;
package Grm::DBIC::Ensembl::Result::AnalysisDescription;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AnalysisDescription

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<analysis_description>

=cut

__PACKAGE__->table("analysis_description");

=head1 ACCESSORS

=head2 analysis_description

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 display_label

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 displayable

  data_type: 'enum'
  default_value: 1
  extra: {list => [0,1]}
  is_nullable: 0

=head2 web_data

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "analysis_description",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "display_label",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "displayable",
  {
    data_type => "enum",
    default_value => 1,
    extra => { list => [0, 1] },
    is_nullable => 0,
  },
  "web_data",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</analysis_description>

=back

=cut

__PACKAGE__->set_primary_key("analysis_description");

=head1 UNIQUE CONSTRAINTS

=head2 C<analysis_idx>

=over 4

=item * L</analysis_id>

=back

=cut

__PACKAGE__->add_unique_constraint("analysis_idx", ["analysis_id"]);

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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FaURwDuyGJP/fl2jhT26pQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
