package Grm::DBIC::Ensembl::Result::Dnac;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::Dnac

=cut

__PACKAGE__->table("dnac");

=head1 ACCESSORS

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sequence

  accessor: undef
  data_type: 'mediumblob'
  is_nullable: 0

=head2 n_line

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "seq_region_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "sequence",
  { accessor => undef, data_type => "mediumblob", is_nullable => 0 },
  "n_line",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("seq_region_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-02 16:25:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qcaGNzAJjRO6ChdNEBgV9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
