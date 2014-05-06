#!/usr/local/bin/perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Data::Dump 'dump';
use File::Basename;
use Getopt::Long;
use Grm::DB;
use Grm::Ontology;
use Grm::Utils qw( commify timer_calc commify );
use File::CountLines qw( count_lines );
use File::Spec::Functions;
use JSON::XS qw( decode_json );
use LWP::Simple qw( get );
use IO::Prompt qw( prompt );
use List::MoreUtils qw( zip );
use Pod::Usage;
use Readonly;
use Template;

Readonly my $NCBI_UNKNOWN_TAXA_ID => '32644';
Readonly my @FIELD_NAMES => qw(
    db db_object_id db_object_symbol qualifier term_accession db_reference
    evidence_code with aspect db_object_name db_object_synonym db_object_type
    taxon date assigned_by annotation_extension gene_product_form_id url
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

my $timer    = timer_calc();
my $odb      = Grm::Ontology->new;
my $schema   = $odb->db->dbic;

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

my %species_cache;
my ( $num_files, $num_assocs ) = ( 0, 0 );
my $file_count = scalar @files;
my $file_width = length $file_count;
my $tt         = Template->new;

for my $file ( @files ) {
    my $num_lines = count_lines( $file );

    open my $fh, '<', $file;

    printf 
        "%${file_width}d/%${file_width}d: Processing %s line%s in '%s'\n", 
        ++$num_files, 
        $file_count,
        commify($num_lines),
        $num_lines == 1 ? '' : 's',
        basename($file);

    my @field_names = @FIELD_NAMES;
    my $line_num    = 0;
    REC:
    for my $line ( <$fh> ) {
        $line_num++;

        next if $line =~ /^!/; # comment

        chomp $line;

        my @data = split /\t/, $line;

        if ($line_num == 1) {
            @field_names = @data;
            next REC;
        }

        my %rec = zip @field_names, @data;

        my $term_acc = $rec{'term_accession'} || $rec{'go_id'};

        if ( !$term_acc ) {
            say STDERR "No term_accession or go_id";
            next REC;
        }

        my @term_ids;
        for my $r ( 
            [ 'Term'       , 'term_accession' ], 
            [ 'TermSynonym', 'term_synonym'   ] 
        ) {
            my ( $rs, $fld ) = @$r;
            @term_ids = map { $_->term_id() }
                $schema->resultset( $rs )->search({ $fld, $term_acc });
            last if @term_ids;
        }

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

        my $obj_id     = $rec{'db_object_id'}     || '';
        my $obj_type   = $rec{'db_object_type'}   || '';
        my $obj_name   = $rec{'db_object_name'}   || '';
        my $obj_symbol = $rec{'db_object_symbol'} || '';
        my $taxon      = $rec{'taxon'}            || '';

        unless ( $obj_id && $obj_type ) {
            say STDERR "Line $line_num: no type and name/ID";
            next REC;
        }

        if ( $Term->is_obsolete ) {
            my $alternates 
                = $odb->obsolete_term_alternates( term_id => $Term->id );

            say $obsolete_fh join("\t",
                $term_acc, $obj_type, $obj_id, 
                join(',', map { $_->{'parent_acc'} } @$alternates)
            );

            if ( @$alternates == 1 ) {
                my $alt = shift @$alternates;

                my $new_term_acc = $alt->{'parent_acc'};
                my (@Terms) = $schema->resultset('Term')->search({
                    term_accession => $new_term_acc
                });

                if ( @Terms == 1 ) {
                    $term_acc = $new_term_acc;
                    $Term = shift @Terms;
                }
            }
        }

        if ( !defined $species_cache{ $taxon } ) {
            $species_cache{ $taxon } = get_species( 
                $odb, $schema, $taxon, $rec{'db'} 
            );
        }

        my $Species = $species_cache{ $taxon };

        my $Type = $schema->resultset('AssociationObjectType')->find_or_create(
            { type => $obj_type },
        );

        my $Object = $schema->resultset('AssociationObject')->find_or_create({ 
            db_object_id               => $obj_id, 
            db_object_name             => $obj_name, 
            db_object_symbol           => $obj_symbol,
            association_object_type_id => $Type->id,
            species_id                 => $Species->id,
        });

        if ( my $url = $rec{'url'} ) {
            $Object->url( $url );
            $Object->update;
        }

        if ( my $syn = $rec{'db_object_synonym'} ) {
            $Object->db_object_synonym( $syn );
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
    my ( $odb, $schema, $taxon, $db_name ) = @_;

    $taxon //= '';
    $taxon =~ s/^taxon://;

    my $ncbi_taxa_id = '';

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
    elsif ( $taxon =~ /^\d+$/ ) {
        my $ncbi_tax_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/' .
            'esummary.fcgi?db=taxonomy&id=%s&retmode=json';
        my $json = decode_json(get(sprintf($ncbi_tax_url, $taxon)));
        my $info = $json->{'result'}{ $taxon };

        if ( $info->{'status'} eq 'merged' ) {
            if ( my $new_tax_id = $info->{'akataxid'} ) {
                $taxon = $new_tax_id;
                my $new_tax = decode_json(get(sprintf($ncbi_tax_url, $taxon)));
                $info = $new_tax->{'result'}{ $taxon };
            }
        }

        my ( $genus, $species, $common_name );
        if ( $info->{'error'} ) {
            if ( $db_name =~ /^ensembl_([a-z]+)_([a-z]+)/ ) {
                $genus       = $1;
                $species     = $2;
                $common_name = join(' ', $genus, $species);
            }
        }
        else {
            $genus       = $info->{'genus'};
            $species     = $info->{'species'};
            $common_name = $info->{'commonname'};
        }

        if ( $genus && $species ) {
            $Species = $schema->resultset('Species')->find_or_create({ 
                ncbi_taxa_id => $taxon,
                genus        => $genus,
                species      => $species,
            });

            if ( $common_name ) {
                $Species->common_name($common_name);
                $Species->update;
            }
        }
    }

    $Species ||= $schema->resultset('Species')->find_or_create({ 
        ncbi_taxa_id => $NCBI_UNKNOWN_TAXA_ID,
        common_name  => 'Unclassified',
    });

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
