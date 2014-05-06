#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Class::Load 'load_class';
use Cwd 'cwd';
use Data::Dump 'dump';
use File::Basename 'basename';
use File::Path 'mkpath';
use File::Spec::Functions;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( commify timer_calc );
use Pod::Usage;
use Readonly;
use Readonly;
use Template;
use Try::Tiny qw( try catch );

Readonly my $ALL => '__all__';
Readonly my @FLDS => qw[ 
    id title taxon species name biotype seq_region 
    start end description content 
];

my $out_dir      = cwd();
my $species_list = $ALL;
my ( $help, $man_page );
GetOptions(
    'o|out:s'     => \$out_dir,
    's|species:s' => \$species_list,
    'help'        => \$help,
    'man'         => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

if ( !-d $out_dir ) {
    mkpath $out_dir;
}

my $gconf         = Grm::Config->new();
my $search_conf   = $gconf->get('search');
my %valid_species = map  { s/^ensembl_//; $_, 1 } 
                    grep {  /^ensembl_/ } 
                    $gconf->get('modules');

my ( @species, @bad_species );
SPECIES:
for my $s ( split( /\s*,\s*/, lc $species_list ) ) {
    if ( $s eq $ALL ) {
        @species = sort keys %valid_species;
        last SPECIES;
    }
    elsif ( $valid_species{ $s } ) {
        push @species, $s;
    }
    else {
        push @bad_species, $s;
    }
}

if ( @bad_species ) {
    die join("\n", 
        'Bad species:', 
        map { " - $_" } @bad_species
    ), "\n";
}

printf "Will export %s species to '%s.'\n", scalar @species, $out_dir;

my @sql = split(/\s*;\s*/, $search_conf->{'sql_to_index'}{'ensembl_*.gene'});

my $tt          = Template->new();
my $total_t     = timer_calc();
my $num_species = 0;
for my $species ( sort @species ) {
    my $t = timer_calc();
    my ( $num_genes, $num_markers ) = ( 0, 0 );
    try {
        (my $pretty = ucfirst($species) ) =~ s/_/ /g;
        printf "%3d: %s\n", ++$num_species, $pretty;

        my $module   = 'ensembl_' . $species;
        my $db       = Grm::DB->new($module);
        my $schema   = $db->schema;
        my $dbh      = $db->dbh;
        my $taxon_id = $dbh->selectrow_array(
            q[
                select meta_value as ncbi_taxonomy_id
                from   meta 
                where  meta_key='species.taxonomy_id'
            ]
        ) || '';

        #
        # Get title template (if any)
        #
        my %title_tmpl;
        if ( my %title_def = %{ $search_conf->{'title'} || {} } ) {
            for my $table ( qw[ gene marker ] ) {
                LOOP:
                for my $def_obj_type ( keys %title_def ) {
                    my ( $def_module, $def_table ) = split /\./, $def_obj_type;
                    my $title_def = $title_def{ $def_obj_type };

                    if ( 
                           $module =~ /$def_module/
                        && $table eq $def_table
                        && $title_def =~ /^TT:(.*)/ 
                    ) {
                        $title_tmpl{ $table } = $1;
                        last LOOP;
                    }
                }
            }
        }

        my $file = catfile( $out_dir, $species . '.tab' );
        open my $fh, '>', $file;
        print $fh join( "\t", @FLDS ), "\n";

        for my $Gene ( $schema->resultset('Gene')->all() ) {
            printf "%-70s\r", sprintf '%10s genes', commify(++$num_genes);
            my @content;
            for my $sql ( @sql ) {
                next unless $sql =~ /\?/;
                my @data = @{ $dbh->selectall_arrayref( $sql, {}, $Gene->id ) } 
                    or next;

                for my $rec ( @data ) {
                    for my $text ( grep { defined } @$rec ) {
                        push @content, $text;
                    }
                }
            }

            my $title = make_title( 
                tt       => $tt,
                template => $title_tmpl{'gene'} || '',
                species  => $species,
                module   => $module,
                table    => 'gene',
                object   => $Gene
            );

            print $fh join("\t",
                join( '/', $module, 'gene', $Gene->id ),
                $title,
                $taxon_id,
                $species,
                $Gene->stable_id(),
                $Gene->biotype(),
                $Gene->seq_region->name(),
                $Gene->seq_region_start(),
                $Gene->seq_region_end(),
                $Gene->description() || '',
                join(' ', @content ) || '',
            ), "\n";
        }

        print "\n" if $num_genes;

        for my $Marker ( $schema->resultset('Marker')->all() ) {
            printf "%-70s\r", sprintf '%10s markers', commify(++$num_markers);

            for my $f ( $Marker->marker_features() ) {
                ( my $name = $Marker->display_marker_synonym->name ) 
                    =~ s/\.\d+$//;

                my $title = make_title( 
                    tt       => $tt,
                    template => $title_tmpl{'marker'} || '',
                    species  => $species,
                    module   => $module,
                    table    => 'marker',
                    object   => $Marker,
                );

                print $fh join("\t",
                    join( '/', $module, 'marker', $f->id ),
                    $title,
                    $taxon_id,
                    $species,
                    $name,
                    'marker',
                    $f->seq_region->name,
                    $f->seq_region_start,
                    $f->seq_region_end,
                    '', # description
                    '', # content
                ), "\n";
            }
        }

        print "\n" if $num_markers;

        printf "===> Wrote '%s' in %s.\n", basename($file), $t->();
    }
    catch {
        warn "error: $_";
    }
}

printf "Done processed %s species in %s.\n", $num_species, $total_t->();
exit(0);

# ----------------------------------------------------
sub make_title {
    my %args     = @_;
    my $tt       = $args{'tt'};
    my $object   = $args{'object'};
    my $template = $args{'template'} || '';
    my $module   = $args{'module'}   || '';
    my $table    = $args{'table'}    || '';
    my $species  = $args{'species'}  || '';

    if ( $species ) {
        $species = ucfirst $species;
        $species =~ s/_/ /g;
    }

    my $title = '';
    if ( $template ) {
        $tt->process(
            \$template,
            {
                object      => $object,
                module      => $module,
                table       => $table,
                object_type => $table,
                species     => $species,
            },
            \$title
        ) or $title = $tt->error;
    }
    else {
        $title = join(' ', map { $_ || () } 
            $species || $module, 
            $table, 
            $object->id,
        );
    }

    return $title;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

export-genome-features.pl - export genome features from Ensembl for Solr

=head1 SYNOPSIS

  export-genome-features.pl [-o out_dir] [-s species]

Options:

  -o|--out      Directory to write output file (default cwd)
  -s|--species  Comma-separated list of species to process (default all)
  --help        Show brief help and exit
  --man         Show full documentation

=head1 DESCRIPTION

Exports a tab-delimited file from Ensembl for genes and markers to be 
processed for Solr.

=head1 SEE ALSO

Solr, Grm::Search.

=head1 AUTHOR

kclark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
