#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use DBI;
use Getopt::Long;
use Grm::Config;
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

my $build_version = '';
my ( $help, $man_page );
GetOptions(
    'v|build-version:s' => \$build_version,
    'help'              => \$help,
    'man'               => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $conf = Grm::Config->new;

if ( !$build_version ) {
    $build_version = $conf->get('version') or pod2usage("No build version");
}

my @errors;
MODULE:
for my $module ( grep { /^ontology_/ } $conf->get('modules') ) {
    ( my $amigo_name = $module ) =~ s/ontology/amigo/;
    my $cur_db_name  = $amigo_name . $build_version;
    my $prev_db_name = $amigo_name . ( $build_version - 1 );
    my $db_conf      = $conf->get('database');
    my $host         = $db_conf->{'default'}{'host'};

    my @args = (
        $db_conf->{'default'}{'user'},
        $db_conf->{'default'}{'password'},
        { RaiseError => 1 }
    );

    my $cur_db = DBI->connect(
        "dbi:mysql:host=$host;database=$cur_db_name", @args
    );

    my $prev_db;
    eval {
        $prev_db = DBI->connect(
            "dbi:mysql:host=$host;database=$prev_db_name", @args
        );
    };

    if ( $@ || !$prev_db ) {
        print "Error checking '$prev_db_name,' skipping.\n";
        next MODULE;
    }
    
    printf "Checking $prev_db_name => $cur_db_name\n";

    my $tables = $cur_db->selectcol_arrayref('show tables');

    for my $t ( @$tables ) {
        my $sql        = "select count(*) from $t";
        my $cur_count  = $cur_db->selectrow_array( $sql );
        my $prev_count = $prev_db->selectrow_array( $sql );

        if ( $cur_count != $prev_count ) {
            push @errors, { 
                table => "$cur_db_name.$t",
                prev  => $prev_count,
                cur   => $cur_count,
            }
        }
    }
}

if ( @errors ) {
    my @flds = qw( table prev cur );
    my $tab  = Text::TabularDisplay->new( @flds );

    for my $err ( @errors ) {
        $tab->add( map { $err->{ $_ } } @flds );
    }

    my $num = scalar @errors;

    print join "\n", 
        $tab->render, 
        sprintf( 'Found %s error%s.', $num, $num == 1 ? '' : 's' ),,
        ''
    ;
}
else {
    print "Found no problems.\n";
}

print "Done.\n";

__END__

# ----------------------------------------------------

=pod

=head1 NAME

amigo-load-check.pl - checks load of Amigo dbs from ontology files

=head1 SYNOPSIS

  amigo-load-check.pl 

Options:

  -v|--build-version  Integer value of build to check, e.g., "36"
  --help              Show brief help and exit
  --man               Show full documentation

=head1 DESCRIPTION

Checks current "amigo_*" dbs against files, previous loads.

=head1 SEE ALSO

perl.

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
