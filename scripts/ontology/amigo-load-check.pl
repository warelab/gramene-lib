#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use DBI;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils 'commify';
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

my $cur_db_name  = 'amigo' . $build_version;
my $prev_db_name = 'amigo' . ( $build_version - 1 );
my $amigo_db     = Grm::DB->new('amigo');
my $host         = $amigo_db->host;

my @args = (
    $amigo_db->user,
    $amigo_db->password,
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
    die "Error checking '$prev_db_name,' skipping.\n";
}

say "Checking $prev_db_name => $cur_db_name";

my $sql = 'select count(*) as count, term_type from term group by 2';
my $cur_count  = $cur_db->selectall_hashref( $sql, 'term_type' );
my $prev_count = $prev_db->selectall_hashref( $sql, 'term_type' );

my @results;
for my $term_type ( sort keys %$prev_count ) {
    next unless $term_type;

    my $cur  = $cur_count->{ $term_type }{'count'}  || 0;
    my $prev = $prev_count->{ $term_type }{'count'} || 0;

    push @results, { 
        term_type => $term_type,
        prev      => sprintf( '%9s', commify($prev) ),
        cur       => sprintf( '%9s', commify($cur)  ),
        ok        => $prev <= $cur ? '' : 'BAD',
    };
}

if ( @results ) {
    my @flds = qw( term_type prev cur ok );
    my $tab  = Text::TabularDisplay->new( 
        'term_type', $prev_db_name, $cur_db_name, 'ok' 
    );

    for my $res ( @results ) {
        $tab->add( map { $res->{ $_ } } @flds );
    }

    say $tab->render;
}
else {
    say 'Found nothing?';
}

say 'Done';

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
