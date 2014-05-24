#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dumper;
use DateTime;
use File::Basename;
use File::Path 'mkpath';
use File::Spec::Functions;
use Getopt::Long;
use Grm::DB;
use Grm::Ontology;
use Grm::Utils qw( commify timer_calc );
#use Gramene::QTL::DB;
use IO::Prompt 'prompt';
use List::MoreUtils qw( uniq );
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

Readonly my $SOURCE_DB => 'Gramene';

# cf. http://www.geneontology.org/GO.format.gaf-2_0.shtml#aspect
Readonly my %ONTOLOGY_ASPECT   => (
    plant_environment_ontology => 'E',
    plant_trait_ontology       => 'T',
    biological_process         => 'P',
    cellular_component         => 'C',
    molecular_function         => 'F',
);

Readonly my @OUT_FIELDS => qw(
    db
    db_object_id
    db_object_symbol
    qualifier
    term_accession
    db_reference
    evidence_code
    with
    aspect
    db_object_name
    db_object_synonym
    db_object_type
    taxon
    date
    assigned_by
    annotation_extension
    gene_product_form_id
    url
);

my $selected_modules = 'all';
my $out_dir = '';
my ( $force, $list_modules, $help, $man_page );
GetOptions(
    'd|dir:s'    => \$out_dir,
    'l|list'     => \$list_modules,
    'f|force'    => \$force,
    'm|module:s' => \$selected_modules,
    'help'       => \$help,
    'man'        => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my %DISPATCH  =  (
    all       => { expands => 1, run => undef },
    ensembl   => { expands => 1, run => '_export_ensembl' },
);

my $gconf = Grm::Config->new;
{
    my @all_modules = $gconf->get('modules');
    while ( my ( $module, $conf ) = each %DISPATCH ) {
        if ( $conf->{'expands'} ) {
            for my $other ( grep { /^$module/ } @all_modules ) {
                $DISPATCH{ $other } = { 
                    expands => 0, 
                    run     => $conf->{'run'},
                };
            }
        }
    }
}

my %valid = map { $_, 1 } keys %DISPATCH;

if ( $list_modules ) {
    print join "\n", 
        'Modules:',
        ( map { " - $_" } sort keys %valid ),
        '',
    ;

    exit 0;
}

my @selected_modules = sort uniq( split /\s*,\s*/, $selected_modules );

if ( my @bad = grep { !defined $valid{ $_ } } @selected_modules ) {
    pod2usage( sprintf( "Invalid modules:\n  %s\n", join(', ', @bad) ) );
}

if ( grep { /^all$/i } @selected_modules ) {
    @selected_modules = 
        sort grep { !$DISPATCH{ $_ }{'expands'} } 
        keys %DISPATCH;
}

my @tmp;
for my $module ( @selected_modules ) {
    if ( $DISPATCH{ $module }{'expands'} ) {
        push @tmp, grep { /^$module/  } $gconf->get('modules');
    }
    else {
        push @tmp, $module;
    }
}

@selected_modules = uniq( @tmp );

if ( !$out_dir ) {
    pod2usage('No output directory');
}

if ( !-d $out_dir ) {
    mkpath $out_dir;
}

if ( !$force ) {
    my $yn = prompt -yn, sprintf "OK to process these?\n%s\n [yn] ",
        join "\n", map { " - $_" } sort @selected_modules;

    if ( !$yn ) {
        say 'OK, bye.';
        exit 0;
    }
}

#
# Make a jazz noise here...
#

my $timer  = timer_calc();
my $dt     = DateTime->now;
(my $date  = $dt->ymd) =~ s/-//g;
my $odb    = Grm::Ontology->new;
my $odbh   = $odb->db->dbh;

my ( %fh_cache, %object_results, %ontology_results, %term_cache );
my $total_count = 0;

for my $module ( sort @selected_modules ) {
    my $count    = 0;
    my $progress = sub { 
        my $msg  = shift || '';
        printf "%-70s\r", sprintf(
            "Exporting %s ... %s", $module, $msg || ++$count
        );
    };
    $progress->('working');

    my $assocs;
    {
        no strict 'refs';
        my $sub_name = $DISPATCH{ $module }{'run'};
        $assocs      = $sub_name->( $module, $progress ); 
    }

    $count ||= scalar @$assocs;
    print "\n" if $count > 0;

    if ( ref $assocs eq 'ARRAY' && @$assocs ) {
        my @obsolete_terms;
        my $assoc_num = 0;
        ASSOC:
        for my $assoc ( @$assocs ) {
            my $term_acc = $assoc->{'term_accession'} or die sprintf( 
                "ERROR: No term accession\n%s\n", Dumper($assoc) 
            );

            $assoc_num++;
            printf "%-70s\r", sprintf( "%10s (%3d%%): %s", 
                commify($assoc_num), 
                int(($assoc_num/$count) * 100), 
                $term_acc
            );

            if (!defined $term_cache{$term_acc}) {
                $term_cache{$term_acc} 
                    = $odb->search_accessions($term_acc) || '';
            }

            my $Term = $term_cache{$term_acc};
            if (!$Term) {
                printf "Bad term '$term_acc'\n%s", Dumper($assoc);
                next ASSOC;
            }

            my $ont_type = $Term->term_type->prefix;
            my $fh = get_fh( $out_dir, $module, $ont_type );

            $assoc->{'db'}           ||= $SOURCE_DB;
            $assoc->{'assigned_by'}  ||= $SOURCE_DB;
            $assoc->{'date'}         ||= $date;
            $assoc->{'db_reference'} ||= 'GR_REF:8396';
            $assoc->{'aspect'}       ||= 
                $ONTOLOGY_ASPECT{ $Term->term_type->term_type } || '';

            if ( $Term->is_obsolete ) {
                push @obsolete_terms, $assoc;
            }
    
            say $fh join( "\t", map { $assoc->{ $_ } || '' } @OUT_FIELDS );

            $object_results{ $module }++;
            $ontology_results{ $ont_type }++;
            $total_count++;
        }

        print "\n";

        if ( @obsolete_terms ) {
            my $file = catfile $out_dir, 
                       join('_', lc $module, 'obsolete.tab');

            printf "%-70s\n", sprintf("  %s obsolete terms to '%s'", 
                commify(scalar @obsolete_terms), basename($file)
            );

            open my $fh, '>', $file;

            my @flds = qw[ 
                taxon db_object_id db_object_name term_accession alternates 
            ];

            say $fh join "\t", @flds;

            my $obs_num = 0;
            for my $assoc ( @obsolete_terms ) {
                $assoc->{'alternates'} = join (', ', 
                    map { $_->{'parent_acc'} } @{
                        $odb->obsolete_term_alternates( 
                            term_acc => $assoc->{'term_accession'} 
                        )
                    }
                );

                printf "%-70s\r", sprintf('  %s: %s => %s', 
                    ++$obs_num, 
                    $assoc->{'term_accession'}, 
                    substr( $assoc->{'alternates'}, 0, 30 ) 
                );
    
                say $fh join "\t", map { $assoc->{ $_ } || '' } @flds;
            }

            close $fh;
        }
    }
    else {
        $object_results{ $module } = 0;
    }
}

print "\n";

#
# Report
#
for my $ref ( 
    [ 'Object Type', \%object_results   ], 
    [ 'Ontology'   , \%ontology_results ],
) {
    my ( $title, $data ) = @$ref;

    next unless %$data;

    my $tab = Text::TabularDisplay->new( $title, 'Count' );

    for my $type ( sort keys %$data ) {
        $tab->add( $type, sprintf('%10s', commify($data->{ $type })) );
    }

    say $tab->render;
}

printf "\nFinished exporting %s association%s in %s.\n",
    commify($total_count), 
    $total_count == 1 ? '' : 's',
    $timer->(),
;

exit 0;

# ----------------------------------------------------
# main done, subs follow
# ----------------------------------------------------
sub get_fh {
    my $dir          = shift; 
    my $object_type  = lc shift;
    my $ont_type     = lc shift;

    if ( !$fh_cache{ $object_type }{ $ont_type } ) {
        my $out_file = catfile $dir, join( '',
            $ont_type, '_', $object_type, '.gaf'
        );

        open my $fh, '>', $out_file;

        print $fh join("\t", @OUT_FIELDS ), "\n";

        $fh_cache{ $object_type }{ $ont_type } = $fh;
    }

    return $fh_cache{ $object_type }{ $ont_type };
}

# ----------------------------------------------------
sub _export_ensembl {
    my ( $species, $progress ) = @_;

    my $config   = Grm::Config->new;
    my $db       = Grm::DB->new( $species );
    my $dbh      = $db->dbh;
    my $taxon_id = $dbh->selectrow_array(
        q[  
            select meta_value as ncbi_taxonomy_id
            from   meta 
            where  meta_key='species.taxonomy_id'
        ]
    );

    my @sql = (
        qq[ 
            select g.gene_id       as db_object_id,
                   g.stable_id     as db_object_symbol,
                   g.description   as db_object_name,
                   x.description   as term_name,
                   x.dbprimary_acc as term_accession,
                   gx.linkage_type as evidence_code
            from   xref x,
                   object_xref ox,
                   ontology_xref gx,
                   translation p,
                   transcript t,
                   gene g,
                   external_db e
            where  ox.ensembl_object_type='Translation'
            and    ox.ensembl_id=p.translation_id
            and    p.transcript_id=t.transcript_id
            and    t.gene_id=g.gene_id
            and    ox.object_xref_id=gx.object_xref_id
            and    x.dbprimary_acc is not null
            and    ox.xref_id=x.xref_id
            and    x.external_db_id=e.external_db_id
            and    e.db_name in ('GO', 'PO', 'TO', 'EO')
        ],
        qq[
            select g.gene_id       as db_object_id,
                   g.stable_id     as db_object_symbol,
                   g.description   as db_object_name,
                   x.description   as term_name,
                   x.dbprimary_acc as term_accession,
                   gx.linkage_type as evidence_code
            from   xref x,
                   object_xref ox,
                   ontology_xref gx,
                   transcript t,
                   gene g,
                   external_db e
            where  ox.ensembl_object_type='Transcript'
            and    ox.ensembl_id=t.transcript_id
            and    t.gene_id=g.gene_id
            and    ox.object_xref_id=gx.object_xref_id
            and    ox.xref_id=x.xref_id
            and    x.dbprimary_acc is not null
            and    x.external_db_id=e.external_db_id
            and    e.db_name in ('GO', 'PO', 'TO', 'EO')
        ],
    );

    my @data;
    for my $sql ( @sql ) { 
        push @data, @{ $dbh->selectall_arrayref( $sql, { Columns => {} } ) };
    }

    my $obj_type = 'gene';
    map { 
        $_->{'db'}             = $species;
        $_->{'taxon'}          = $taxon_id;
        $_->{'db_object_type'} = $obj_type;
        $_->{'url'}            = join(
            '/', '', 'view', $species, $obj_type, $_->{'db_object_symbol'}
        );
    } @data;

    return \@data;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

export-ontology-assocs.pl - a script

=head1 SYNOPSIS

  export-ontology-assocs.pl -d /tmp/assocs -m qtl

Required arguments:

  -d|--dir   Output dir

Options:

  -f|--force  Don't prompt for confirmation
  -l|--list   Show list of valid export modules
  -m|--module Comma-separated list of modules to export (default "all")
  --help      Show brief help and exit
  --man       Show full documentation

=head1 DESCRIPTION

Exports ontology associations from various databases to tab-delimited 
GAF 2.0 files suitable for importing into ontology db and uploading to 
Gramene FTP.

 +-----+------------------------------+-----------+----------------------+
 | Col | Content                      | Required? | Example              |
 +-----+------------------------------+-----------+----------------------+
 | 1   | DB                           | required  | UniProtKB            |
 | 2   | DB Object ID                 | required  | P12345               |
 | 3   | DB Object Symbol             | required  | PHO3                 |
 | 4   | Qualifier                    | optional  | NOT                  |
 | 5   | GO ID                        | required  | GO:0003993           |
 | 6   | DB:Reference (|DB:Reference) | required  | PMID:2676709         |
 | 7   | Evidence Code                | required  | IMP                  |
 | 8   | With (or) From               | optional  | GO:0000346           |
 | 9   | Aspect                       | required  | F                    |
 | 10  | DB Object Name               | optional  | Toll-like receptor 4 |
 | 11  | DB Object Synonym (|Synonym) | optional  | hToll|Tollbooth      |
 | 12  | DB Object Type               | required  | protein              |
 | 13  | Taxon(|taxon)                | required  | taxon:9606           |
 | 14  | Date                         | required  | 20090118             |
 | 15  | Assigned By                  | required  | SGD                  |
 | 16  | Annotation Extension         | optional  | part_of(CL:0000576)  |
 | 17  | Gene Product Form ID         | optional  | UniProtKB:P12345-2   |
 +-----+------------------------------+-----------+----------------------+

=head1 SEE ALSO

Grm::Ontology, http://www.geneontology.org/GO.format.gaf-2_0.shtml.

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
