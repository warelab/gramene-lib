#!/usr/local/bin/perl

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
use Gramene::QTL::DB;
use IO::Prompt 'prompt';
use List::MoreUtils 'uniq';
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

Readonly my $SOURCE_DB => 'Gramene';
Readonly my %ONTOLOGY_ASPECT => (
    eo  => 'E',
    to  => 'T',
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
);

my $object_types = 'all';
my $out_dir      = '';
my ( $force, $show_types, $help, $man_page );
GetOptions(
    'd|dir:s'    => \$out_dir,
    'l|list'     => \$show_types,
    'f|force'    => \$force,
    'm|module:s' => \$object_types,
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
    diversity => { expands => 1, run => '_export_diversity' },
    ensembl   => { expands => 1, run => '_export_ensembl' },
    qtl       => { expands => 0, run => '_export_qtl' },
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

if ( $show_types ) {
    print join "\n", 
        'Valid types:',
        ( map { " - $_" } sort keys %valid ),
        '',
    ;

    exit 0;
}

my @object_types = sort uniq split /\s*,\s*/, $object_types;

if ( my @bad = grep { !defined $valid{ $_ } } @object_types ) {
    pod2usage( sprintf( "Invalid types:\n  %s\n", join(', ', @bad) ) );
}

if ( grep { /^all$/i } @object_types ) {
    @object_types = sort grep { !$DISPATCH{ $_ }{'expands'} } keys %DISPATCH;
}

my @tmp;
for my $obj_type ( @object_types ) {
    if ( $DISPATCH{ $obj_type }{'expands'} ) {
        push @tmp, grep { /^$obj_type/  } $gconf->get('modules');
    }
    else {
        push @tmp, $obj_type;
    }
}

@object_types = sort uniq @tmp;

if ( !$out_dir ) {
    pod2usage('No output directory');
}

if ( !-d $out_dir ) {
    mkpath $out_dir;
}

if ( !$force ) {
    my $yn = prompt -yn, sprintf "OK to process these?\n%s\n [yn] ",
        join "\n", map { " - $_" } @object_types;

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

my ( %fh_cache, %object_results, %ontology_results );
my $total_count = 0;

for my $obj_type ( sort @object_types ) {
    my $count    = -1;
    my $progress = sub { 
        printf "%-70s\r", sprintf("Exporting %s ... %s", $obj_type, ++$count);
    };
    $progress->();

    my $assocs;
    {
        no strict 'refs';
        my $sub_name = $DISPATCH{ $obj_type }{'run'};
        $assocs      = &$sub_name( $obj_type, $progress ); 
    }

    print "\n" if $count > 0;

    if ( ref $assocs eq 'ARRAY' && @$assocs ) {
        my %obsolete_term;
        my $assoc_num;
        ASSOC:
        for my $assoc ( @$assocs ) {
            my $term_acc = $assoc->{'term_accession'} or die sprintf( 
                "ERROR: No term accession\n%s\n", Dumper($assoc) 
            );

            printf "%-70s\r", sprintf( "%10s (%3d%%): %s", 
                commify(++$assoc_num), 
                int(($assoc_num/$count) * 100), 
                $term_acc
            );

            my $ont_type;
            if ( 
                $term_acc =~ /([A-Z]{2,3})[:]\d+/ ||  
                $term_acc =~ /(GR_tax)[:]\d+/ 
            ) {
                $ont_type = $1;
            }
            else {
                printf "Can't figure out ontology prefix from '$term_acc'\n%s",
                    Dumper($assoc);
                next ASSOC;
            }

            my $fh = get_fh( $out_dir, $obj_type, $ont_type );

            $assoc->{'db'}          ||= $SOURCE_DB;
            $assoc->{'assigned_by'} ||= $SOURCE_DB;
            $assoc->{'aspect'}      ||= $ONTOLOGY_ASPECT{ lc $ont_type } || '';
            $assoc->{'date'}        ||= $date;

            if ( !defined $obsolete_term{ $term_acc } ) {
                my $is_obsolete = $odbh->selectrow_array(
                    'select is_obsolete from term where term_accession=?', {},
                    $term_acc
                );

                $obsolete_term{ $term_acc }++ if $is_obsolete;
            }
    
            say $fh join( "\t", map { $assoc->{ $_ } || '' } @OUT_FIELDS );

            $object_results{ $obj_type }++;
            $ontology_results{ $ont_type }++;
            $total_count++;
        }

        print "\n";

        if ( %obsolete_term ) {
            my $file = catfile $out_dir, 
                       join('_', lc $obj_type, 'obsolete.tab');

            printf "%-70s\n", sprintf("  %s obsolete terms to '%s'", 
                commify(scalar keys %obsolete_term), basename($file)
            );

            open my $fh, '>', $file;

            say $fh join "\t", qw[ term_acc alternates ];

            my $obs_num;
            for my $term_acc ( keys %obsolete_term ) {
                my $alternates = join (', ', 
                    map { $_->{'parent_acc'} } @{
                        $odb->obsolete_term_alternates( term_acc => $term_acc )
                    }
                );

                printf "%-70s\r", sprintf('  %s: %s => %s', 
                    ++$obs_num, $term_acc, substr( $alternates, 0, 30) 
                );
    
                say $fh join "\t", $term_acc, $alternates;
            }

            close $fh;
        }
    }
    else {
        $object_results{ $obj_type } = 0;
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
        my $out_file = catfile $dir, "${ont_type}-${object_type}.gaf";

        open my $fh, '>', $out_file;

        print $fh join("\n",
            '!gaf-version: 2.0',
            '!' . join( "\t", @OUT_FIELDS ),
            ''
        );

        $fh_cache{ $object_type }{ $ont_type } = $fh;
    }

    return $fh_cache{ $object_type }{ $ont_type };
}

# ----------------------------------------------------
sub _export_qtl {
    my ( $module_name, $progress ) = @_;
    my $qtl_db   = Grm::DB->new('qtl');
    my $dbh      = $qtl_db->dbh;
    my $schema   = $qtl_db->dbic;
    my $qdb      = Gramene::QTL::DB->new;

    my @assocs;
    my $qtl_ids = $dbh->selectcol_arrayref('select qtl_id from qtl');
    my $total   = scalar @$qtl_ids;

    for my $qtl_id ( @$qtl_ids ) {
        my $Qtl = $schema->resultset('Qtl')->find( $qtl_id );
        $progress->();

        for my $assoc ( $qdb->get_qtl_associations( qtl_id => $qtl_id ) ) {
            next unless $assoc->{'association_type'} eq 'ontology';

            my ( $evidence_code, $db_ref ) = ( '', '' );
            if ( 
                ref $assoc->{'evidence'} eq 'ARRAY' &&
                @{ $assoc->{'evidence'} || [] }
            ) {
                my $ev         = $assoc->{'evidence'}[0];
                $evidence_code = $ev->{'evidence_code'};
                $db_ref        = 'GR_REF:' . $ev->{'gramene_reference_id'};
            }

            push @assocs, {
                db                => 'GR_QTL',
                db_object_id      => $Qtl->qtl_accession_id,
                db_object_symbol  => $Qtl->qtl_trait->trait_symbol,
                term_accession    => $assoc->{'term_accession'},
                db_reference      => $db_ref,
                evidence_code     => $evidence_code,
                db_object_name    => $Qtl->qtl_trait->trait_name,
                db_object_synonym => $Qtl->published_symbol,
                db_object_type    => 'QTL',
                taxon             => 'taxon:' . $Qtl->species->ncbi_taxonomy_id,
            };
        }
    }

    return \@assocs;
}

# ----------------------------------------------------
sub _export_diversity {
    my ( $module_name, $progress ) = @_;
    my $config    = Grm::Config->new;
    my $dconfig   = $config->get('diversity');
    my $tax_ids   = $dconfig->{'tax_id'} or die 'No tax_id in diversity config';
    ( my $species = $module_name ) =~ s/^diversity_//;
    my $tax_id    = $tax_ids->{ $species } or die "No tax id for $species";

    my @assocs;
    my $db   = Grm::DB->new( $module_name );
    my $dbh  = $db->dbh;
    $tax_id  = 'GR_tax:' . $tax_id;

    for my $type ( qw[ to eo ] ) {
        my $traits = $dbh->selectall_arrayref(
            qq[
                select div_trait_uom_id, local_trait_name, 
                       ${type}_accession as acc
                from   div_trait_uom
                where  ${type}_accession is not null
            ],
            { Columns => {} }
        );

        next unless @$traits;

        my $object_type = $type eq 'to' ? 'trait' : 'environment';

        TRAIT:
        for my $trait ( @$traits ) {
            my $term_acc = $trait->{'acc'} or next TRAIT;

            if ( $trait->{'acc'} !~ /^[A-Z]{2,3}[:]\d+$/ ) {
                next TRAIT;
            }

            my $trait_name = $trait->{'local_trait_name'} || $term_acc;

            $progress->();

            push @assocs, {
                db_object_id      => $trait->{'div_trait_uom_id'}, 
                db_object_symbol  => $trait_name,
                term_accession    => $term_acc,
                db_reference      => 'GR_REF:0',
                evidence_code     => 'SM',
                db_object_name    => $trait_name,
                db_object_synonym => '',
                taxon             => $tax_id,
                db_object_type    => join(' ', 
                    ucfirst( $species ), 'Diversity', ucfirst($object_type)
                ),
                db                => join('_', 
                    'GR', 'diversity', $species, 'trait'
                ),
            };
        }
    }

    return \@assocs;
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

    my $sql = q[
        select g.stable_id     as gene, 
               x.description   as term_name, 
               x.dbprimary_acc as term_accession, 
               gx.linkage_type as evidence_code
        from   xref x,
               object_xref ox,
               ontology_xref gx,
               gene g,
               transcript t,
               translation tr,
               external_db db
        where  t.transcript_id=tr.transcript_id
        and    g.gene_id=t.gene_id
        and    ox.xref_id=x.xref_id
        and    ox.object_xref_id=gx.object_xref_id
        and    x.external_db_id=db.external_db_id
        and    db.db_name in ('EO', 'GO', 'PO', 'TO')
    ];

    my $sql_translation = q[ 
        and    ox.ensembl_id=tr.translation_id
        and    ox.ensembl_object_type='Translation'
    ];

    my $sql_transcript = q[ 
        and    ox.ensembl_id=t.transcript_id
        and    ox.ensembl_object_type='Transcript'
    ];

    my $data = $dbh->selectall_arrayref( 
        $sql . $sql_translation,
        { Columns => {} }
    );

    my $total = scalar @$data or return;

    my $type_check = 0;
    my ( %seen, @assocs );
    for my $assoc ( @$data ) {
        my $term_acc = $assoc->{'term_accession'} or next;
        my $gene     = $assoc->{'gene'}           or next;

        next if $seen{ "${term_acc}-${gene}" }++;

        $progress->();
        ( my $obj_type = "$species gene" ) =~ s/_/ /g;

        push @assocs, {
            db                => join('_', 'GR', $species, 'gene'),
            db_object_id      => $gene,
            db_object_symbol  => '',
            term_accession    => $term_acc,
            db_reference      => 'GR_REF:8396',
            evidence_code     => $assoc->{'evidence_code'},
            db_object_name    => '',
            db_object_synonym => '',
            db_object_type    => $obj_type,
            taxon             => $taxon_id,
        };
    }

    return \@assocs;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

export-ontology-assocs.pl - a script

=head1 SYNOPSIS

  export-ontology-assocs.pl -d /tmp/assocs -t qtl

Required arguments:

  -d|--dir   Output dir

Options:

  -f|--force  Don't prompt for confirmation
  -m|--module Comma-separated list of modules to export (default "all")
  -l|--list   Show list of valid export modules
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
