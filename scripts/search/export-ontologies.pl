#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use File::Path 'mkpath';
use File::Spec::Functions;
use Getopt::Long;
use Grm::DB;
use Grm::Utils qw( timer_calc commify );
use HTML::Entities 'decode_entities';
use Pod::Usage;
use Readonly;

Readonly my @FLDS => qw( id name synonym description );
Readonly my $SOLR => 'http://brie.cshl.edu:8983/solr/ontologies/update?'
    . 'commit=true&f.synonym.split=true';

my $out_dir = cwd();
my ( $help, $man_page );
GetOptions(
    'o|out:s' => \$out_dir,
    'help'    => \$help,
    'man'     => \$man_page,
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

my $timer    = timer_calc();
my $db       = Grm::DB->new('ontology');
my $schema   = $db->schema;
my $out_file = catfile( $out_dir, 'ontologies.csv' );
my $term_num = 0;

open my $out, '>', $out_file;
print $out join( ',', @FLDS ), "\n";

print "Gathering ontology terms ... ";
my $count = $schema->resultset('Term')->count();
printf "there are %s.\n", commify($count);

my $num_skipped = 0;
TERM:
for my $Term ( $schema->resultset('Term')->all() ) {
    my $acc = $Term->term_accession || '';

    $term_num++;
    printf "%-70s\r", sprintf( 
        '%10s (%3d%%): %s', 
        commify($term_num), 
        $term_num == $count ? '100' : (($term_num/$count) * 100), 
        $acc 
    );

    my $skip;
    if ( !$acc ) {
        $skip = 'no accession';
    }
    elsif ( $Term->is_obsolete ) {
        $skip = 'is obsolete';
    }
    elsif ( !$Term->term_type->prefix ) {
        $skip = 'no prefix';
    }
    elsif ( !$Term->name ) {
        $skip = 'no name';
    }

    if ( $skip ) {
        printf STDERR "%5s: Skipping %s (%s)\n", ++$num_skipped, $skip;
        next TERM;
    }

    my @syn;
    for my $Syn ( $Term->term_synonyms ) {
        push @syn, $Syn->term_synonym;
    }

    my $def = '';
    if ( my $Def = $Term->term_definition ) {
        $def = $Def->definition;
    }

    print $out join( ',', 
        map { clean($_) }
        $acc,
        $Term->name,
        @syn ? join( ',', @syn ) : '',
        $def,
    ), "\n";
}

close $out;

printf "\nExported %s terms (skipped %s) in %s. Now do this:\n%s\n", 
    commify($term_num), 
    commify($num_skipped), 
    $timer->(), 
    "curl '$SOLR' -H 'Content-type:application/csv' --data-binary \@" 
    . $out_file
;

# ----------------------------------------------------
sub clean {
    my $s = shift || '';

    $s =~ s/[\n\r]//g;       # no CR/LF
    $s =~ s/["']//g;         # kill quotes
    $s =~ s/^\s+|\s+$//g;    # trim
    $s =~ s/\s+/ /g;         # squish spaces
    $s =~ s/[[:^ascii:]]//g; # all non-ASCII text
    $s = decode_entities($s);

    return qq["$s"];
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-ontologies.pl - creates a CSV file for Solr

=head1 SYNOPSIS

  load-ontologies.pl [-o out_dir]

Options:

  -o|--out   Output directory (default is "cwd")
  --help     Show brief help and exit
  --man      Show full documentation

=head1 DESCRIPTION

Dumps the ontology db to a CSV file for Solr.

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
