package Grm::DBIC::AmigoEo::Result::TermSynonym;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::AmigoEo::Result::TermSynonym

=cut

__PACKAGE__->table("term_synonym");

=head1 ACCESSORS

=head2 term_id

  data_type: 'integer'
  is_nullable: 0

=head2 term_synonym

  data_type: 'varchar'
  is_nullable: 1
  size: 996

=head2 acc_synonym

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 synonym_type_id

  data_type: 'integer'
  is_nullable: 0

=head2 synonym_category_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "term_id",
  { data_type => "integer", is_nullable => 0 },
  "term_synonym",
  { data_type => "varchar", is_nullable => 1, size => 996 },
  "acc_synonym",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "synonym_type_id",
  { data_type => "integer", is_nullable => 0 },
  "synonym_category_id",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->add_unique_constraint("term_id", ["term_id", "term_synonym"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2013-02-01 12:34:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Afuhlu+FC2mMv5WWvVBrmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
