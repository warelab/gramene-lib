#!/usr/bin/env perl
#
# ************ Record 1 ************
#           Gene stable ID: OS11G0599200
#     Transcript stable ID: OS11T0599200-01
#        Protein stable ID: OS11T0599200-01
# Chromosome/scaffold name: 11
#          Gene start (bp): 22926178
#            Gene end (bp): 22928035
#                   Strand: -1
#         Gene description: Os11g0599200 protein; UDP-glucoronosyl and UDP-
#                           glucosyl transferase family protein, expressed
#                           [Source:UniProtKB/TrEMBL;Acc:Q2R1N0]
#             % GC content: 65.55
#             Gene biotype: protein_coding
#                Gene name:
#
# 1 record returned

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Carp 'croak';
use Getopt::Long;
use Grm::Ontology;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;
use List::MoreUtils qw( uniq );

Readonly my $URL => 
    'http://brie.cshl.edu:8983/solr/genome_features/update' .
    '?commit=true&f.ontology.split=true';

Readonly my %SCHEMA => (
    id          => '',
    ensembl_id  => 'gene_stable_id',
    species     => '',
    taxon       => '',
    name        => 'gene_name',
    description => 'gene_description',
    biotype     => 'gene_biotype',
    seq_region  => 'chromosome_scaffold_name,chromosomescaffold_name',
    start       => 'gene_start_bp',
    end         => 'gene_end_bp',
    strand      => 'strand',
    percent_gc  => 'gc_content,_gc_content',
    ontology    => '',
    taxonomy    => '',
);

my $species     = '';
my $object_type = '';
my ( $help, $man_page );
GetOptions(
    's|species=s' => \$species,
    'o|object=s'  => \$object_type,
    'help'        => \$help,
    'man'         => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

if ( !$species ) {
    pod2usage('Please indicate species')
}

if ( !$object_type ) {
    pod2usage('Please indicate object type')
}

#
# Gather all the ontology accessions
#
#print "Gathering ontology terms.\n";
#my $odb      = Grm::Ontology->new;
#my $ont_pref = join '|', uniq( $odb->get_ontology_accession_prefixes );
#my %ont_acc  = ();
#{
#    my $dbic    = $odb->db->dbic;
#    my $term_rs = $dbic->resultset('Term');
#    my $syn_rs  = $dbic->resultset('TermSynonym');
#    my $take    = sub { 
#        my $name = shift;
#        if ( $name =~ /^((?:$ont_pref):\d+)$/ig ) {
#            $ont_acc{ lc $name }++;
#        }
#    };
#    
#    while ( my $Term = $term_rs->next ) {
#        $take->( $Term->term_accession );
#    }
#
#    while ( my $Syn = $syn_rs->next ) {
#        $take->( $Syn->term_synonym );
#    }
#}

my $file = shift or pod2usage('No input file');
my $p    = Text::RecordParser::Tab->new( $file );

$p->header_filter( 
    sub { $_ = shift; s/\s+/_/g; s/[^A-Za-z0-9_]//g; lc $_ } 
);

my $out = 'genome_features.csv';
open my $fh, '>', $out;
my @out_flds = sort keys %SCHEMA;
print $fh join( ',', @out_flds ), "\n";

while ( my $r = $p->fetchrow_hashref ) {
#    say dump($r);

    my ( %feature, %this_ont );
    FLD:
    while ( my ( $fld, $src ) = each %SCHEMA ) {
        for my $src_fld ( split( /\s*,\s*/, $src ) ) {
            if ( my $val = $r->{ $src_fld } ) {
#                while ( $val =~ /(($ont_pref):\d+)/ig ) {
#                    my $acc = $1;
#                    if ( $ont_acc{ lc $acc } ) {
#                        $this_ont{ $acc }++;
#                    }
#                }

                $feature{ $fld } = $val;
                next FLD;
            }
        }
    }

    $feature{'id'} //= join '/', $species, $object_type, $feature{'ensembl_id'};

    $feature{'name'} //= $feature{'ensembl_id'};

#    if ( my @term_ids = keys %this_ont ) {
#        $feature{'ontology'} = join ',', @term_ids;
#    }

#    say dump(\%feature);

    print $fh join( ',', 
        map { qq["$_"] }
        map { $feature{ $_ } // '' } 
        @out_flds 
    ), "\n";
}

say "now do this:";
say "curl $URL -H 'Content-type:application/csv' --data-binary \@$out";

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-genome-features.pl - a script

=head1 SYNOPSIS

  load-genome-features.pl -s 'Arabidopsis thaliana' -o gene file.txt

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Import genome feature data into Solr.

=head1 SEE ALSO

Solr.

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
