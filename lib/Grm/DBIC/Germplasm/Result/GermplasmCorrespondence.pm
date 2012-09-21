package Grm::DBIC::Germplasm::Result::GermplasmCorrespondence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Germplasm::Result::GermplasmCorrespondence

=cut

__PACKAGE__->table("germplasm_correspondence");

=head1 ACCESSORS

=head2 germplasm_correspondence_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 germplasm_id1

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 germplasm_id2

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "germplasm_correspondence_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "germplasm_id1",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "germplasm_id2",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("germplasm_correspondence_id");
__PACKAGE__->add_unique_constraint("germplasm_id1", ["germplasm_id1", "germplasm_id2"]);

=head1 RELATIONS

=head2 germplasm_id1

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::Germplasm>

=cut

__PACKAGE__->belongs_to(
  "germplasm_id1",
  "Grm::DBIC::Germplasm::Result::Germplasm",
  { germplasm_id => "germplasm_id1" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 germplasm_id2

Type: belongs_to

Related object: L<Grm::DBIC::Germplasm::Result::Germplasm>

=cut

__PACKAGE__->belongs_to(
  "germplasm_id2",
  "Grm::DBIC::Germplasm::Result::Germplasm",
  { germplasm_id => "germplasm_id2" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:02:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/sHqRtuvd3ikyDKlNUDhAg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
