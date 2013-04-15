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
    say $obj_type;
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

my $timer = timer_calc();
my $dt    = DateTime->now;
(my $date = $dt->ymd) =~ s/-//g;

my ( %fh_cache, %object_results, %ontology_results );

my $total_count = 0;
for my $obj_type ( sort @object_types ) {
    say "Exporting $obj_type";

    my $i = 0;
    my $progress    = sub { 
        my $name    = shift || $obj_type;
        my $total   = shift || 0;
        my $counter = ++$i;

        if ( $total > 0 ) {
            $counter = sprintf('%3d%%/%s', int(($i/$total) * 100), $i);
        }

        printf "%-70s\r", sprintf( "%10s: %s", $counter, $name );

        return $i;
    };

    my $assocs;
    {
        no strict 'refs';
        my $sub_name = $DISPATCH{ $obj_type }{'run'};
        $assocs      = &$sub_name( $obj_type, $progress ); 
    }

    my $count = $progress->();
    printf "%-70s\n", sprintf( "%10s: Done", $count - 1 );

    if ( ref $assocs eq 'ARRAY' && @$assocs ) {
        ASSOC:
        for my $assoc ( @$assocs ) {
            my $term_acc = $assoc->{'term_accession'} or die sprintf( 
                "ERROR: No term accession\n%s\n", Dumper($assoc) 
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

            say $fh join( "\t", map { $assoc->{ $_ } || '' } @OUT_FIELDS );

            $object_results{ $obj_type }++;
            $ontology_results{ $ont_type }++;
            $total_count++;
        }
    }
    else {
        $object_results{ $obj_type } = 0;
    }
}

#
# Report
#
my $msg = sprintf 'Done exporting %s association%s in %s.',
    commify($total_count), 
    $total_count == 1 ? '' : 's',
    $timer->(),
;

my $line = '-' x length $msg;
print join "\n", '', $line, $msg, $line, '', '';

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
        $progress->( $Qtl->qtl_accession_id, $total );

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

        my $object_type = sprintf('%s Diversity %s',
            ucfirst( $species ),
            $type eq 'to' ? 'Trait' : 'Environment'
        );

        TRAIT:
        for my $trait ( @$traits ) {
            my $term_acc = $trait->{'acc'} or next TRAIT;

            if ( $trait->{'acc'} !~ /^[A-Z]{2,3}[:]\d+$/ ) {
                next TRAIT;
            }

            my $trait_name = $trait->{'local_trait_name'} || $term_acc;

            $progress->( "$module_name - $trait_name" );

            push @assocs, {
                db                => "GR_diversity_${species}",
                db_object_id      => $trait->{'div_trait_uom_id'}, 
                db_object_symbol  => $trait_name,
                term_accession    => $term_acc,
                db_reference      => 'GR_REF:0',
                evidence_code     => 'SM',
                db_object_name    => $trait_name,
                db_object_synonym => '',
                db_object_type    => $object_type,
                taxon             => $tax_id,
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

        my $status = join ' - ', $species, $term_acc, $gene;
        $progress->( substr( $status, 0, 50 ), $total );
        ( my $obj_type = "$species gene" ) =~ s/_/ /g;

        push @assocs, {
            db                => 'GR_' . $species,
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

#        if ( !$type_check ) {
#            $sth = $dbh->prepare( $sql . $sql_transcript );
#            $sth->execute() or die $dbh->errstr;
#            while ( my ( $gene, $go_name, $go_acc, $evn )
#                = $sth->fetchrow_array() 
#            ) {
#                my $is_obsolete
#                    = $onto_db->selectrow_array(
#                    'select is_obsolete from term where term_accesssion=?',
#                    {}, 
#                    $go_acc 
#                );
#
#                if ( $is_obsolete ) {
#                    my $alternates = join( ',',
#                        get_obsolete_alternates( $amigo_db, $go_acc ) );
#
#                    print $obs_fh join( "\t", $gene, $go_acc, $alternates ), "\n";
#                }
#
#                my $assoc = join( "\t", ( $gene, $go_name, $go_acc, $evn ) );
#                unless ( $seen_assocs{ $assoc }++ ) {
#                    print_GOC_file( $print_header, $dbc,
#                        $out_fh, $err_fh, $gene, $go_name,
#                        $go_acc, $evn,    $species
#                    );
#                }
#            }
#        }

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
