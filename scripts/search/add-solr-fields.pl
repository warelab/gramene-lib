#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Data::Dump 'dump';
use File::Basename qw( basename fileparse );
use File::Spec::Functions;
use Getopt::Long;
use Grm::Ontology;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( timer_calc camel_case );
use Pod::Usage;
use Readonly;
use List::MoreUtils 'uniq';

Readonly my $FS => chr(31);
Readonly my $RS => chr(30);

#Readonly my $SOLR => 'http://brie.cshl.edu:8983/solr/genome_features/update?'
#    . 'commit=true&f.taxonomy.split=true&f.ontology.split=true';
Readonly my $SOLR => 'http://brie.cshl.edu:8983/solr/grm-search/update?'
    . 'commit=true&f.taxonomy.split=true&f.ontology.split=true';

my $out_dir = '';
my ( $help, $man_page );
GetOptions(
    'd|dir:s' => \$out_dir,
    'help'    => \$help,
    'man'     => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my @files      = @ARGV or die 'No files';
my $num_files  = scalar @files;
my $timer      = timer_calc();
my $config     = Grm::Config->new;
my $sconf      = $config->get('search');
my %title_tmpl = ();

printf "Will process %s file%s\n", $num_files, $num_files == 1 ? '' : 's';

print 'Gathering ontology terms...';
my $odb      = Grm::Ontology->new;
my $ont_pref = join '|', uniq( $odb->get_ontology_accession_prefixes );
my $ont_acc  = get_ontology_terms( $odb );

my %tax;
my $tax_lookup = sub {
    my $tax_id = shift or return;
    if ( !defined $tax{ $tax_id } ) {
        my ($gr_tax) = $odb->db->dbh->selectrow_array(
            q[
                select t.term_accession
                from   term t, term_dbxref tx, dbxref x
                where  x.xref_key=?
                and    x.xref_dbname='NCBI_taxid'
                and    x.dbxref_id=tx.dbxref_id
                and    tx.term_id=t.term_id
            ],
            {},
            $tax_id
        );

        $tax{ $tax_id } = $gr_tax || '';
    }

    return $tax{ $tax_id };
};

my $shell_file = catfile( $out_dir || cwd(), 'send-to-solr.sh' );
open my $sh, '>', $shell_file;

my $file_num = 0;
for my $file ( @files ) {
    local $/ = $RS;

    open my $in, '<', $file;

    my ( $base, $path, $suffix ) = fileparse( $file, qr/\.[^.]*/ );
    my $new_file = catfile( $out_dir || $path, $base . '-ont.csv' );

    open my $out, '>', $new_file;
    chomp( my $header = <$in> );
    my @cols = split $FS, $header;

    $file_num++;
    print $sh "curl '$SOLR' -H 'Content-type:application/csv' --data-binary \@" 
        . $new_file . "\n";

    my @flds = uniq( @cols, qw[ title ontology taxonomy ] );
    print $out join( ',', @flds ), "\n";

    my $i = 0;
    my $t = timer_calc();
    
    while ( my $line = <$in> ) {
        chomp $line;
        my @data = split $FS, $line;
        my %rec  = map { $cols[ $_ ], $data[ $_ ] } 0 .. $#cols;

        printf "%-70s\r", sprintf( '%3d/%3d: %s (line %s)', 
            $file_num, 
            $num_files, 
            basename($file), 
            ++$i,
        );

        my ( %term, %new );
        for my $fld ( @cols ) {
            my $text = $rec{ $fld } // '';

            my @new;
            for my $word (split(/\s+/, $text)) {
                if ( $word =~ m/(($ont_pref):\d+)/i ) {
                    my $acc = $1;
                    if ( $ont_acc->{ lc $acc } ) {
                        $term{ $acc }++;
                        next;
                    }
                }

                push @new, $word;
            }

            $text =  join ' ', @new;
            $text =~ s/["']//g;      # kill quotes
            $text =~ s/\s+/ /g;      # squish
            $text =~ s/^\s+|\s+$//g; # trim
            $new{ $fld } = $text;
        }

        my ( @tax, @ont );
        for my $term ( keys %term ) {
            if ( $term =~ /^gr_tax:/i ) {
                push @tax, $term;
            }
            else {
                push @ont, $term;
            }
        }

        if ( my $gr_tax = $tax_lookup->($rec{'taxon'}) ) {
            push @tax, $gr_tax;
        }

        $new{'title'}    ||= make_title(\%rec, $sconf);
        $new{'taxonomy'} ||= join( ',', @tax );
        $new{'ontology'}   = join( ',', @ont );
        $new{'id'}         =~ s/-/\//g;

        print $out join( ',', map { '"' . $new{ $_ } . '"' } @flds ), "\n";
    }

    close $in;
    close $out;

    printf "\n => %s (%s)\n", $new_file, $t->();
}

close $sh;

printf "Finished in %s.\n", $timer->();
printf "Now do this:\nsh $shell_file\n";

# ----------------------------------------------------
sub make_title {
    my ( $rec, $conf )          = @_;
    my $id                      = $rec->{'id'} or return;
    my ( $module, $table, $pk ) = split( /[\/-]/, $id );

    if ( !defined $title_tmpl{ $module }{ $table } ) {
        if ( my %title_def = %{ $sconf->{'title'} || {} } ) {
            my $tmpl = '';
            LOOP:
            while ( my ( $obj_type, $def ) = each %title_def ) {
                my ( $def_module, $def_table ) = split /\./, $obj_type;

                my @title_vals;
                next
                  unless $module =~ /$def_module/
                  && $table eq $def_table;

                if ( $def =~ /^TT:(.*)/ ) {
                    $tmpl = $1;
                    last LOOP;
                }
            }

            $title_tmpl{ $module }{ $table } = $tmpl;
        }
    }

    my $title_template = $title_tmpl{ $module }{ $table } || '';

    my $species = '';
    if ( $species = $rec->{'species'} ) {
        $species = ucfirst $species;
        $species =~ s/_/ /g;
    }

    my $title = '';
    if ( $title_template ) {
        my $tt     = Template->new;
        my $db     = Grm::DB->new( $module );
        my $schema = $db->schema;
        my $object = $schema->resultset(camel_case($table))->find($pk);

        $tt->process(
            \$title_template,
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
            $rec->{'name'} || $pk,
        );
    }

    return $title;
}

# ----------------------------------------------------
sub get_ontology_terms {
    my $odb   = shift;
    my $cache = './.ont-cache.tab';

    my %ont_acc;
    if ( -e $cache ) {
        print 'reading ontology cache...';
        open my $in, '<', $cache;
        while ( my $term = <$in> ) {
            chomp( $term );
            $ont_acc{ $term }++;
        }
        close $in;
    }
    else {
        printf 'querying %s...', $odb->db->db_name;

        my $dbic    = $odb->db->dbic;
        my $term_rs = $dbic->resultset('Term');
        my $syn_rs  = $dbic->resultset('TermSynonym');
        my $take    = sub { 
            my $name = shift;
            if ( $name =~ /^((?:$ont_pref):\d+)$/ig ) {
                $ont_acc{ lc $name }++;
            }
        };
        
        while ( my $Term = $term_rs->next ) {
            $take->( $Term->term_accession );
        }

        while ( my $Syn = $syn_rs->next ) {
            $take->( $Syn->term_synonym );
        }

        open my $out, '>', $cache;
        for my $term ( keys %ont_acc ) {
            print $out "$term\n";
        }
        close $out;
    }

    print "done.\n";

    return \%ont_acc;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

add-solr-fields.pl - add title, ontology, taxonomy, etc., fields for Solr

=head1 SYNOPSIS

  add-solr-fields.pl file1 [file2 ...]

Options:

  -d|--dir  Output directory (defaults to same dir as input files)
  --help    Show brief help and exit
  --man     Show full documentation

=head1 DESCRIPTION

Reads in tab-delimited files, writes out new ones with new "title,"
"ontology," and "taxonomy" fields for Solr.  Also cleans up text 
(removes non-ASCII characters, extraneous white space, etc.).

=head1 SEE ALSO

Grm::Ontology.

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
