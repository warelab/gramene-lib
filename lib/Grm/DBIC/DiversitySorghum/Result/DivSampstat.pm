package Grm::DBIC::DiversitySorghum::Result::DivSampstat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::DiversitySorghum::Result::DivSampstat

=cut

__PACKAGE__->table("div_sampstat");

=head1 ACCESSORS

=head2 div_sampstat_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 div_sampstat_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sampstat

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 germplasm_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "div_sampstat_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "div_sampstat_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sampstat",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "germplasm_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("div_sampstat_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:01:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IkaDTxRLt0o1TQ7R280vNQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
