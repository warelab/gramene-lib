use utf8;
package Grm::DBIC::Ensembl::Result::Karyotype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::Karyotype

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<karyotype>

=cut

__PACKAGE__->table("karyotype");

=head1 ACCESSORS

=head2 karyotype_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_region_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_region_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 seq_region_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 band

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 stain

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=cut

__PACKAGE__->add_columns(
  "karyotype_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_region_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_region_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "seq_region_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "band",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "stain",
  { data_type => "varchar", is_nullable => 0, size => 40 },
);

=head1 PRIMARY KEY

=over 4

=item * L</karyotype_id>

=back

=cut

__PACKAGE__->set_primary_key("karyotype_id");

=head1 RELATIONS

=head2 seq_region

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::SeqRegion>

=cut

__PACKAGE__->belongs_to(
  "seq_region",
  "Grm::DBIC::Ensembl::Result::SeqRegion",
  { seq_region_id => "seq_region_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-11-06 17:35:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4Lp89Rh3+1gwr84PdcR3yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
