#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Bio::EnsEMBL::Registry;
use Class::Load 'load_class';
use Data::Dump 'dump';
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( commify timer_calc );
use Pod::Usage;
use Readonly;
use Readonly;
use Try::Tiny qw( try catch );

Readonly my $ALL => '__all__';
Readonly my @FLDS => qw[ 
    id taxon species ensembl_id biotype seq_region start end strand description 
    text
];

my $species_list = $ALL;
my ( $help, $man_page );
GetOptions(
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

my $gconf         = Grm::Config->new();
my $search_conf   = $gconf->get('search');
my %valid_species = map  { s/^ensembl_//; $_, 1 } 
                    grep {  /^ensembl_/ } 
                    $gconf->get('modules');
my @sql = split(/\s*;\s*/, $search_conf->{'sql_to_index'}{'ensembl_*.gene'});

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

printf "Will process %s species.\n", scalar @species;

my $total_t  = timer_calc();
my $registry = 'Bio::EnsEMBL::Registry';
my $ens_conf = $gconf->{'ensembl'}          || {};
my $reg_file = $ens_conf->{'registry_file'} || '';

load_class( $registry );
$registry->load_all( $reg_file );

my $num_species = 0;
for my $species ( sort @species ) {
    my $t = timer_calc();
    my ( $num_genes, $num_markers ) = ( 0, 0 );
    try {
        (my $pretty = ucfirst($species) ) =~ s/_/ /g;
        printf "%3d: %s\n", ++$num_species, $pretty;

        my $db       = Grm::DB->new('ensembl_' . $species);
        my $schema   = $db->schema;
        my $dbh      = $db->dbh;
        my $taxon_id = $dbh->selectrow_array(
            q[
                select meta_value as ncbi_taxonomy_id
                from   meta 
                where  meta_key='species.taxonomy_id'
            ]
        ) || '';

        my $file = $species . '.tab';
        open my $fh, '>', $file;
        print $fh join( "\t", @FLDS ), "\n";

        for my $Gene ( $schema->resultset('Gene')->all() ) {
            printf "%-70s\r", sprintf '%6s genes', ++$num_genes;
            my %text;
            for my $sql ( @sql ) {
                next unless $sql =~ /\?/;
                my @data = @{ $dbh->selectall_arrayref( $sql, {}, $Gene->id ) } 
                    or next;

                for my $rec ( @data ) {
                    for my $text ( grep { defined } @$rec ) {
                        $text{ $text }++;
                    }
                }
            }

            my $text = join(' ', keys %text );

            print $fh join("\t",
                join( '-', $species, 'gene', $Gene->stable_id() ),
                $taxon_id,
                $species,
                $Gene->stable_id(),
                $Gene->biotype(),
                $Gene->seq_region->name(),
                $Gene->seq_region_start(),
                $Gene->seq_region_end(),
                $Gene->seq_region_strand(),
                $Gene->description() || '',
                $text,
            ), "\n";
        }
        print "\n";

        for my $Marker ( $schema->resultset('Marker')->all() ) {
            printf "%-70s\r", sprintf '%6s markers', ++$num_markers;

            for my $f ( $Marker->marker_features() ) {
                ( my $name = $Marker->display_marker_synonym->name ) 
                    =~ s/\.\d+$//;

                print $fh join("\t",
                    join( '-', $species, 'marker', $f->id ),
                    $taxon_id,
                    $species,
                    $name,
                    'marker',
                    $f->seq_region->name,
                    $f->seq_region_start,
                    $f->seq_region_end,
                    '', # strand
                    '', # description
                    '', # text
                ), "\n";
            }
        }
        printf "\nFinished in %s", $t->();
    }
    catch {
        warn "error: $_";
    }
}

printf "Done processed %s species in %s.\n", $num_species, $total_t->();

__END__

# ----------------------------------------------------

=pod

=head1 NAME

export-genome-features.pl - export genome features from Ensembl for Solr

=head1 SYNOPSIS

  export-genome-features.pl [-s oryza_sativa ]

Options:

  --help   Show brief help and exit
  --man    Show full documentation

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
