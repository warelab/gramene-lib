package Grm::DBIC::Maps::Result::FeatureDetailsAflp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Maps::Result::FeatureDetailsAflp

=cut

__PACKAGE__->table("feature_details_aflp");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 molecular_weight

  data_type: 'integer'
  is_nullable: 1

=head2 adapter1_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter1_restriction

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter1_sequence

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter1_complement

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter2_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter2_restriction

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter2_sequence

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 adapter2_complement

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer1_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer1_common_seq

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer1_overhang

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer2_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer2_common_seq

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer2_overhang

  data_type: 'varchar'
  is_nullable: 1
  size: 50

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
  "molecular_weight",
  { data_type => "integer", is_nullable => 1 },
  "adapter1_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter1_restriction",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter1_sequence",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter1_complement",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter2_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter2_restriction",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter2_sequence",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "adapter2_complement",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer1_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer1_common_seq",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer1_overhang",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer2_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer2_common_seq",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer2_overhang",
  { data_type => "varchar", is_nullable => 1, size => 50 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wlBLNeuJkLjQRBmRzfnYhg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
