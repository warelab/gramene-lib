#!/usr/local/bin/perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Data::Dumper;
use File::Basename;
use Getopt::Long;
use Grm::DB;
use Grm::Ontology;
use Grm::Utils qw( commify timer_calc commify );
use File::CountLines qw( count_lines );
use File::Spec::Functions;
use IO::Prompt qw( prompt );
use Pod::Usage;
use Readonly;

Readonly my $NCBI_UNKNOWN_TAXA_ID => '32644';
Readonly my @FIELD_NAMES => qw(
    db db_object_id db_object_symbol qualifier term_accession db_reference
    evidence_code with aspect db_object_name db_object_synonym db_object_type
    taxon date assigned_by annotation_extension gene_product_form_id
);

my $reinitialize = 0;
my ( $help, $man_page );
GetOptions(
    'r'    => \$reinitialize,
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $timer  = timer_calc();
my $odb    = Grm::Ontology->new;
my $schema = $odb->db->dbic;

my @files;
{
    my @bad;
    for my $arg ( @ARGV ) {
        printf "%-70s\r", 'Checking input file ' . basename($arg);
        if ( -e $arg && -s _ && -r _ ) {
            push @files, $arg;
        }
        else {
            push @bad, $arg;
        }
    }

    if ( @bad ) {
        print join "\n",
            'Bad file arguments:',
            ( map { " - $_" } @bad ),
            '',
        ;
        exit 0;
    }

    printf "%-70s\n", sprintf('Will process %s files', commify(scalar @files));
    @ARGV = ();
}

if ( !@files ) {
    pod2usage('No files');
}

if ( $reinitialize ) {
    my $ok = prompt -yn, 
        'Are you sure you want to remove all association data? [yn] ';

    if ( $ok ) {
        for my $table ( qw[ 
            association association_object association_object_type species
        ] ) {
            say " - Truncating '$table'";
            $odb->db->dbh->do("delete from $table");
        }
    }
    else {
        say 'OK, bye.';
        exit 0;
    }
}

my $obsolete_file = catfile( cwd(), 'obsolete-terms.txt' );
open my $obsolete_fh, '>', $obsolete_file;
say $obsolete_fh join("\t", qw[term_acc obj_type obj_name alternates]);

my ( $num_files, $num_assocs ) = ( 0, 0 );
my $file_count = scalar @files;
my $file_width = length $file_count;

for my $file ( @files ) {
    my $num_lines = count_lines( $file );

    open my $fh, '<', $file;

    printf 
        "%${file_width}d/%${file_width}d: Processing %s line%s in file '%s'\n", 
        ++$num_files, 
        $file_count,
        commify($num_lines),
        $num_lines == 1 ? '' : 's',
        basename($file);

    my $line_num = 0;
    REC:
    for my $line ( <$fh> ) {
        $line_num++;

        next if $line =~ /^!/; # comment

        chomp $line;

        my @data = split /\t/, $line;
        my %rec  = map { $FIELD_NAMES[$_], $data[$_] } 0..$#FIELD_NAMES;

        my $term_acc = $rec{'term_accession'} || $rec{'go_id'};

        if ( !$term_acc ) {
            say STDERR "No term_accession or go_id";
            next REC;
        }

        my @term_ids = $odb->search( 
            query                  => $term_acc,
            include_obsolete_terms => 1,
        );

        if ( @term_ids != 1 ) {
            printf STDERR "For '$term_acc', found %s terms\n", scalar @term_ids;
            next REC;
        }

        my $term_id = shift @term_ids;
        my $Term = $schema->resultset('Term')->find( $term_id );

        if ( !$Term ) {
            say STDERR "Can't retrieve term '$term_id'";
            next REC;
        }

        my $obj_id   = $rec{'db_object_id'}   or next;
        my $obj_type = $rec{'db'}             || '';
        my $obj_name = $rec{'db_object_name'} || '';
        my $taxon    = $rec{'taxon'}          || 'NA';

        unless ( $obj_id && $obj_type ) {
            say STDERR "Line $line_num: no type and name/ID";
            next REC;
        }

        if ( $Term->is_obsolete ) {
            my $alternates 
                = $odb->obsolete_term_alternates( term_id => $Term->id );

            say $obsolete_fh join("\t",
                $term_acc, $obj_type, $obj_name, 
                join(',', map { $_->{'parent_acc'} } @$alternates)
            );

            if ( @$alternates == 1 ) {
                my $alt = shift @$alternates;

                my $new_term_acc = $alt->{'parent_acc'};
                my (@Terms) = $schema->resultset('Term')->search({
                    term_accession => $new_term_acc
                });

                if ( @Terms == 1 ) {
                    printf STDERR "Moving from obsolete term '%s' => '%s'\n",
                        $term_acc, $new_term_acc;

                    $term_acc = $new_term_acc;
                    $Term = shift @Terms;
                }
            }
        }

        my $Species = get_species( $odb, $schema, $taxon );
        my $Type = $schema->resultset('AssociationObjectType')->find_or_create(
            { type => $obj_type },
        );

        my $Object = $schema->resultset('AssociationObject')->find_or_create(
            { 
                db_object_id               => $obj_id, 
                db_object_name             => $obj_name, 
                association_object_type_id => $Type->id,
                species_id                 => $Species->id,
            },
        );

        if ( my $symbol = $rec{'db_object_symbol'} ) {
            $Object->db_object_symbol( $symbol );
            $Object->update;
        }

        printf "%-70s\r", sprintf "  %10s (%3d%%): %s => %s", 
            commify($line_num), 
            $line_num == $num_lines ? '100' : int($line_num/$num_lines * 100), 
            $Term->term_accession,
            $obj_id,
        ;

        my $Assoc = $schema->resultset('Association')->find_or_create({ 
            association_object_id => $Object->id,
            term_id               => $Term->id,
            evidence_code         => $rec{'evidence_code'},
        });
    }

    print "\n";
    $num_assocs += $line_num;
}

printf "Done, processed %s association%s in %s file%s in %s\n",
    commify($num_assocs),
    $num_assocs == 1 ? '' : 's',,
    commify($num_files),
    $num_files == 1 ? '' : 's',
    $timer->(),
;

exit 0;

# ----------------------------------------------------
sub get_species {
    my $odb          = shift;
    my $schema       = shift;
    my $taxon        = shift or return;
    my $ncbi_taxa_id = '';

    $taxon =~ s/^taxon://;

    my ( $Species, $Term );

    if ( $taxon =~ /^\d+$/ ) {
        ($Species) = $schema->resultset('Species')->find({ 
            ncbi_taxa_id => $taxon 
        });

        if ( $Species ) {
            return $Species;
        }
        else {
            my $term_id = $odb->db->dbh->selectrow_array(
                q[
                    select t.term_id
                    from   term t, term_dbxref tx, dbxref x
                    where  x.xref_dbname=?
                    and    x.xref_key=?
                    and    x.dbxref_id=tx.dbxref_id
                    and    tx.term_id=t.term_id
                ],
                {},
                ( 'NCBI_taxid', $taxon )
            );
            
            if ( $term_id ) {
                $ncbi_taxa_id = $taxon;
                ($Term) = $schema->resultset('Term')->find( $term_id );
            }
        }
    }
    elsif ( $taxon =~ /^GR_tax:/ ) {
        ($Term) = $schema->resultset('Term')->search(
            { term_accession => $taxon }
        ) or die "Can't find GR_tax '$taxon'";

        if ( $Term ) {
            $ncbi_taxa_id = $odb->db->dbh->selectrow_array(
                q[
                    select x.xref_key
                    from   term_dbxref tx, dbxref x
                    where  x.xref_dbname=?
                    and    x.dbxref_id=tx.dbxref_id
                    and    tx.term_id=?
                ],
                {},
                ( 'NCBI_taxid', $Term->id )
            );
        }
    }

    if ( $Term ) {
        my ( $genus, $species, @junk ) = split( /\s+/, $Term->name, 3 );
        ($Species) = $schema->resultset('Species')->find_or_create(
            { 
                common_name  => $Term->name,
                genus        => $genus,
                species      => $species,
                ncbi_taxa_id => $ncbi_taxa_id || '',
            }
        );
    }

    $Species ||= $schema->resultset('Species')->find_or_create(
        { 
            ncbi_taxa_id => $NCBI_UNKNOWN_TAXA_ID,
            common_name  => 'Unclassified',
        }
    );

    return $Species;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-associations.pl - loads GAF association files

=head1 SYNOPSIS

  load-associations.pl file1.gaf [file2.gaf ...]

Options:

  -r       Reinitialize all the tables related to associations
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Loads the GAF files from "export-ontology-assocs.pl."

=head1 SEE ALSO

export-ontology-assocs.pl

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2013 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
