package Grm::DBIC::Literature::Result::SourceSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Literature::Result::SourceSynonym

=cut

__PACKAGE__->table("source_synonym");

=head1 ACCESSORS

=head2 source_synonym_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 source_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 source_synonym

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "source_synonym_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "source_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "source_synonym",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("source_synonym_id");
__PACKAGE__->add_unique_constraint("source_id_2", ["source_id", "source_synonym"]);

=head1 RELATIONS

=head2 source

Type: belongs_to

Related object: L<Grm::DBIC::Literature::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "source",
  "Grm::DBIC::Literature::Result::Source",
  { source_id => "source_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-09-21 19:12:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Aj7Glnh66QpcDxhWLxtkug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
