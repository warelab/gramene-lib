use utf8;
package Grm::DBIC::Ontology::Result::DataBase;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ontology::Result::DataBase

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<data_base>

=cut

__PACKAGE__->table("data_base");

=head1 ACCESSORS

=head2 data_base_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 55

=head2 fullname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 datatype

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 generic_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url_syntax

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "data_base_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 55 },
  "fullname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "datatype",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "generic_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url_syntax",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</data_base_id>

=back

=cut

__PACKAGE__->set_primary_key("data_base_id");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 15:00:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:svP5HlspzQWE5hllN+w0PA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
