package Grm::DBIC::Diversity::Result::GrmSnpAssoc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Diversity::Result::GrmSnpAssoc

=cut

__PACKAGE__->table("grm_snp_assoc");

=head1 ACCESSORS

=head2 grm_snp_assoc_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 chr

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 chr_num

  data_type: 'integer'
  is_nullable: 1

=head2 object_name

  data_type: 'char'
  is_nullable: 0
  size: 25

=head2 object_type

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 start

  data_type: 'integer'
  is_nullable: 0

=head2 stop

  data_type: 'integer'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "grm_snp_assoc_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "chr",
  { data_type => "char", is_nullable => 1, size => 10 },
  "chr_num",
  { data_type => "integer", is_nullable => 1 },
  "object_name",
  { data_type => "char", is_nullable => 0, size => 25 },
  "object_type",
  { data_type => "char", is_nullable => 0, size => 10 },
  "start",
  { data_type => "integer", is_nullable => 0 },
  "stop",
  { data_type => "integer", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("grm_snp_assoc_id");
__PACKAGE__->add_unique_constraint("chr", ["chr", "object_name", "object_type", "start", "stop"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 18:16:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5w48oMmouN4bGoSt4w490g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
