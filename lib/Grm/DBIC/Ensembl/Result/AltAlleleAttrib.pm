use utf8;
package Grm::DBIC::Ensembl::Result::AltAlleleAttrib;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grm::DBIC::Ensembl::Result::AltAlleleAttrib

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<alt_allele_attrib>

=cut

__PACKAGE__->table("alt_allele_attrib");

=head1 ACCESSORS

=head2 alt_allele_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 attrib

  data_type: 'enum'
  extra: {list => ["IS_REPRESENTATIVE","IS_MOST_COMMON_ALLELE","IN_CORRECTED_ASSEMBLY","HAS_CODING_POTENTIAL","IN_ARTIFICIALLY_DUPLICATED_ASSEMBLY","IN_SYNTENIC_REGION","HAS_SAME_UNDERLYING_DNA_SEQUENCE","IN_BROKEN_ASSEMBLY_REGION","IS_VALID_ALTERNATE","SAME_AS_REPRESENTATIVE","SAME_AS_ANOTHER_ALLELE","MANUALLY_ASSIGNED","AUTOMATICALLY_ASSIGNED"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "alt_allele_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "attrib",
  {
    data_type => "enum",
    extra => {
      list => [
        "IS_REPRESENTATIVE",
        "IS_MOST_COMMON_ALLELE",
        "IN_CORRECTED_ASSEMBLY",
        "HAS_CODING_POTENTIAL",
        "IN_ARTIFICIALLY_DUPLICATED_ASSEMBLY",
        "IN_SYNTENIC_REGION",
        "HAS_SAME_UNDERLYING_DNA_SEQUENCE",
        "IN_BROKEN_ASSEMBLY_REGION",
        "IS_VALID_ALTERNATE",
        "SAME_AS_REPRESENTATIVE",
        "SAME_AS_ANOTHER_ALLELE",
        "MANUALLY_ASSIGNED",
        "AUTOMATICALLY_ASSIGNED",
      ],
    },
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-12-17 17:39:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:umfW6LGmSRkod/iO74yYpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
