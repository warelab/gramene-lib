use utf8;
package Grm::DBIC::Ensembl::Result::AltAllele;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AltAllele

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<alt_allele>

=cut

__PACKAGE__->table("alt_allele");

=head1 ACCESSORS

=head2 alt_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 alt_allele_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "alt_allele_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "alt_allele_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "gene_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</alt_allele_id>

=back

=cut

__PACKAGE__->set_primary_key("alt_allele_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gene_idx>

=over 4

=item * L</gene_id>

=back

=cut

__PACKAGE__->add_unique_constraint("gene_idx", ["gene_id"]);

=head1 RELATIONS

=head2 active_alt_allele

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::AltAllele>

=cut

__PACKAGE__->might_have(
  "active_alt_allele",
  "Grm::DBIC::Ensembl::Result::AltAllele",
  { "foreign.alt_allele_id" => "self.alt_allele_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 alt_allele

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::AltAllele>

=cut

__PACKAGE__->belongs_to(
  "alt_allele",
  "Grm::DBIC::Ensembl::Result::AltAllele",
  { alt_allele_id => "alt_allele_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 alt_allele_group

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::AltAlleleGroup>

=cut

__PACKAGE__->belongs_to(
  "alt_allele_group",
  "Grm::DBIC::Ensembl::Result::AltAlleleGroup",
  { alt_allele_group_id => "alt_allele_group_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 gene

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "Grm::DBIC::Ensembl::Result::Gene",
  { gene_id => "gene_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i+YFyB2EFdHVqodW+6VBtA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
