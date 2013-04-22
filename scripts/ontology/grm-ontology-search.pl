#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;
use File::Basename;
use Getopt::Long;
use Grm::Ontology;
use Grm::Utils 'commify';
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

my ( $help, $man_page );
GetOptions(
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my @queries = (map { split /\s*,\s*/ } @ARGV) or pod2usage('No queries');

my $odb       = Grm::Ontology->new;
my $schema    = $odb->db->dbic;
my $tab       = Text::TabularDisplay->new( qw[ id acc name ] );
my $num_found = 0;

for my $qry ( map { split /\s*,\s*/ } @ARGV ) {
    print "Searching for '$qry' ... ";

    my $term_ids = $odb->search( query => $qry );
    my $found    = scalar @$term_ids;

    printf "found %s\n", commify($found);

    for my $term_id ( @$term_ids ) {
        my $Term = $schema->resultset('Term')->find( $term_id );
        $tab->add( $term_id, $Term->term_accession, $Term->name );
    }

    $num_found += $found;
}

print "\n";

if ( $num_found > 0 ) {
    say $tab->render;
}

say "Found $num_found terms.";

__END__

# ----------------------------------------------------

=pod

=head1 NAME

grm-ontology-search.pl - search Gramene ontology db

=head1 SYNOPSIS

  grm-ontology-search.pl TO:0000303,TO:0000304 TO:0000305

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Searches the Gramene ontology db.

=head1 SEE ALSO

Grm::Ontology.

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
