package Grm::DBIC::Maps::Result::FeatureDetailsRflp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsRflp

=cut

__PACKAGE__->table("feature_details_rflp");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 dna_treatment

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 source_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 source_tissue

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 source_treatment

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 vector

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 vector_antibiotic_resistance

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 fragment_size

  data_type: 'double precision'
  is_nullable: 1

=head2 vector_excision_enzyme

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 vector_primers

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 overgo1

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 30

=head2 overgo2

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "feature_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "dna_treatment",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "source_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "source_tissue",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "source_treatment",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "vector",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "vector_antibiotic_resistance",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "fragment_size",
  { data_type => "double precision", is_nullable => 1 },
  "vector_excision_enzyme",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "vector_primers",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "overgo1",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 30 },
  "overgo2",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 30 },
);
__PACKAGE__->set_primary_key("feature_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Grm::DBIC::Maps::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Grm::DBIC::Maps::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-19 17:21:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:85dHfAkH33D1vy9z6FTMvQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
