use utf8;
package Grm::DBIC::Variation::Result::ProteinFunctionPrediction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::ProteinFunctionPrediction

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<protein_function_predictions>

=cut

__PACKAGE__->table("protein_function_predictions");

=head1 ACCESSORS

=head2 translation_md5_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 analysis_attrib_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 prediction_matrix

  data_type: 'mediumblob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "translation_md5_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "analysis_attrib_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "prediction_matrix",
  { data_type => "mediumblob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</translation_md5_id>

=item * L</analysis_attrib_id>

=back

=cut

__PACKAGE__->set_primary_key("translation_md5_id", "analysis_attrib_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j+ZEU3NfDRfq3Fr6T6MRnA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
