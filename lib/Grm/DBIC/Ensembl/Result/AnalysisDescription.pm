package Grm::DBIC::Ensembl::Result::AnalysisDescription;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::AnalysisDescription

=cut

__PACKAGE__->table("analysis_description");

=head1 ACCESSORS

=head2 analysis_id

  data_type: 'smallint'
  extra: {unsigned => 1}
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
  "analysis_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
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
__PACKAGE__->add_unique_constraint("analysis_idx", ["analysis_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Rh/p98zhCrBPvZXkfEVEyw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
