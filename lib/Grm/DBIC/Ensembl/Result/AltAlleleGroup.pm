use utf8;
package Grm::DBIC::Ensembl::Result::AltAlleleGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AltAlleleGroup

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<alt_allele_group>

=cut

__PACKAGE__->table("alt_allele_group");

=head1 ACCESSORS

=head2 alt_allele_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "alt_allele_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</alt_allele_group_id>

=back

=cut

__PACKAGE__->set_primary_key("alt_allele_group_id");

=head1 RELATIONS

=head2 alt_alleles

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::AltAllele>

=cut

__PACKAGE__->has_many(
  "alt_alleles",
  "Grm::DBIC::Ensembl::Result::AltAllele",
  { "foreign.alt_allele_group_id" => "self.alt_allele_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xu9ZD97y9+vzxGLylChlqQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
