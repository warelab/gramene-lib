package Grm::DBIC::Diversity::Result::AuxMapInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::AuxMapInfo

=cut

__PACKAGE__->table("aux_map_info");

=head1 ACCESSORS

=head2 aux_map_info_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cdv_map_feature_id

  data_type: 'integer'
  is_nullable: 1

=head2 name_gene_locus

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 pioneer_chr

  data_type: 'integer'
  is_nullable: 1

=head2 comments

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ibm2_2005_bin

  data_type: 'double precision'
  is_nullable: 1

=head2 all_ibm2_2005_bins

  data_type: 'text'
  is_nullable: 1

=head2 pioneer_position

  data_type: 'double precision'
  is_nullable: 1

=head2 locus_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 physical_position

  data_type: 'double precision'
  is_nullable: 1

=head2 unigene_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ibm2_2005_chr

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 ibm2_2005_position

  data_type: 'double precision'
  is_nullable: 1

=head2 all_ibm2_2005_positions

  data_type: 'text'
  is_nullable: 1

=head2 fpc_contig

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 fpc_chr

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 fpc_start

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 fpc_stop

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 all_fpc_positions

  data_type: 'text'
  is_nullable: 1

=head2 candidate

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 sort_ibm2_2005_bin

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_ibm2_2005_chr

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_ibm2_2005_position

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_fpc_contig

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_fpc_chr

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_fpc_start

  data_type: 'double precision'
  is_nullable: 1

=head2 sort_fpc_stop

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aux_map_info_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cdv_map_feature_id",
  { data_type => "integer", is_nullable => 1 },
  "name_gene_locus",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "pioneer_chr",
  { data_type => "integer", is_nullable => 1 },
  "comments",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ibm2_2005_bin",
  { data_type => "double precision", is_nullable => 1 },
  "all_ibm2_2005_bins",
  { data_type => "text", is_nullable => 1 },
  "pioneer_position",
  { data_type => "double precision", is_nullable => 1 },
  "locus_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "physical_position",
  { data_type => "double precision", is_nullable => 1 },
  "unigene_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ibm2_2005_chr",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "ibm2_2005_position",
  { data_type => "double precision", is_nullable => 1 },
  "all_ibm2_2005_positions",
  { data_type => "text", is_nullable => 1 },
  "fpc_contig",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "fpc_chr",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "fpc_start",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "fpc_stop",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "all_fpc_positions",
  { data_type => "text", is_nullable => 1 },
  "candidate",
  { data_type => "char", is_nullable => 1, size => 1 },
  "sort_ibm2_2005_bin",
  { data_type => "double precision", is_nullable => 1 },
  "sort_ibm2_2005_chr",
  { data_type => "double precision", is_nullable => 1 },
  "sort_ibm2_2005_position",
  { data_type => "double precision", is_nullable => 1 },
  "sort_fpc_contig",
  { data_type => "double precision", is_nullable => 1 },
  "sort_fpc_chr",
  { data_type => "double precision", is_nullable => 1 },
  "sort_fpc_start",
  { data_type => "double precision", is_nullable => 1 },
  "sort_fpc_stop",
  { data_type => "double precision", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("aux_map_info_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:17:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ltO1qLJhPnKOKHe9DE+hgA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
