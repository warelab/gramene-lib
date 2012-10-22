package Grm::DBIC::Ensembl::Result::ObjectXref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';


=head1 NAME

Grm::DBIC::Ensembl::Result::ObjectXref

=cut

__PACKAGE__->table("object_xref");

=head1 ACCESSORS

=head2 object_xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ensembl_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 ensembl_object_type

  data_type: 'enum'
  extra: {list => ["RawContig","Transcript","Gene","Translation","Operon","OperonTranscript"]}
  is_nullable: 0

=head2 xref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 linkage_annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 analysis_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "object_xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ensembl_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "ensembl_object_type",
  {
    data_type => "enum",
    extra => {
      list => [
        "RawContig",
        "Transcript",
        "Gene",
        "Translation",
        "Operon",
        "OperonTranscript",
      ],
    },
    is_nullable => 0,
  },
  "xref_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "linkage_annotation",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "analysis_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);
__PACKAGE__->set_primary_key("object_xref_id");
__PACKAGE__->add_unique_constraint(
  "xref_idx",
  ["xref_id", "ensembl_object_type", "ensembl_id", "analysis_id"],
);

=head1 RELATIONS

=head2 dependent_xref

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::DependentXref>

=cut

__PACKAGE__->might_have(
  "dependent_xref",
  "Grm::DBIC::Ensembl::Result::DependentXref",
  { "foreign.object_xref_id" => "self.object_xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 identity_xref

Type: might_have

Related object: L<Grm::DBIC::Ensembl::Result::IdentityXref>

=cut

__PACKAGE__->might_have(
  "identity_xref",
  "Grm::DBIC::Ensembl::Result::IdentityXref",
  { "foreign.object_xref_id" => "self.object_xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 xref

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Xref>

=cut

__PACKAGE__->belongs_to(
  "xref",
  "Grm::DBIC::Ensembl::Result::Xref",
  { xref_id => "xref_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 analysis

Type: belongs_to

Related object: L<Grm::DBIC::Ensembl::Result::Analysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Grm::DBIC::Ensembl::Result::Analysis",
  { analysis_id => "analysis_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 ontology_xrefs

Type: has_many

Related object: L<Grm::DBIC::Ensembl::Result::OntologyXref>

=cut

__PACKAGE__->has_many(
  "ontology_xrefs",
  "Grm::DBIC::Ensembl::Result::OntologyXref",
  { "foreign.object_xref_id" => "self.object_xref_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-10-17 13:45:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:v0RgVqBx5zhlHCBetQehRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
