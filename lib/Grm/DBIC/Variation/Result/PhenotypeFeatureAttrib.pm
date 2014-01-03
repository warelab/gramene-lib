use utf8;
package Grm::DBIC::Variation::Result::PhenotypeFeatureAttrib;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Variation::Result::PhenotypeFeatureAttrib

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<phenotype_feature_attrib>

=cut

__PACKAGE__->table("phenotype_feature_attrib");

=head1 ACCESSORS

=head2 phenotype_feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 attrib_type_id

  data_type: 'integer'
  is_nullable: 1

=head2 value

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "phenotype_feature_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "attrib_type_id",
  { data_type => "integer", is_nullable => 1 },
  "value",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-18 14:36:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B43EF4dJBdrgfFat4arsZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
