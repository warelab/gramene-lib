#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use File::Basename 'basename';
use File::CountLines 'count_lines';
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( commify );
use IO::Prompt qw( prompt );
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

Readonly my $TABLE_SQL => q[
    CREATE TABLE IF NOT EXISTS search (
        search_id int (11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        species varchar(64), 
        gene_name	varchar(30) NOT NULL,
        enzyme_name varchar(255) NOT NULL,
        reaction_id	varchar(100) NOT NULL,
        reaction_name varchar(255) NOT NULL,
        ec	varchar(30) NOT NULL,
        pathway_id varchar(100) NOT NULL,
        pathway_name varchar(255) NOT NULL
    )
];

my $species = '';
my $file    = '';
my $list    = '';
my $force   =  0;
my ( $help, $man_page );
GetOptions(
    'f|file=s'    => \$file,
    'force'       => \$force,
    'l|list'      => \$list,
    's|species=s' => \$species,
    'help'        => \$help,
    'man'         => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $gconf = Grm::Config->new;

if ( $list ) {
    my @modules = grep { /^pathway_/ } $gconf->get('modules');

    printf "Valid species:\n%s\n", join( "\n", map { "  - $_" } @modules );
    exit 0;
}

if ( !$file ) {
    pod2usage('Missing file');
}

if ( !$species ) {
    pod2usage('Missing species, use "list" option to see valid options');
}

my $config_name = $species;
if ( $config_name !~ /^pathway_/ ) {
    $config_name = 'pathway_' . $species;
}

my $db      = Grm::DB->new( $config_name );
my $db_name = $db->real_name;;
my $dbh     = $db->dbh;

if ( !$force ) {
    my $ok = prompt -yn, "OK to TRUNCATE and load data into '$db_name'? ";

    if ( !$ok ) {
        say 'Not OK, exiting.';
        exit 0;
    }
}
else {
    printf "Loading '%s' into '%s'\n", basename($file), $config_name;
}

for my $sql ( $TABLE_SQL, 'TRUNCATE TABLE search' ){
    $dbh->do( $sql );
}

my $lc   = count_lines( $file ) - 1; # account for header
my $p    = Text::RecordParser::Tab->new( $file );
my @flds = $p->field_list;
my $sql  = sprintf(
    'insert into search ( %s ) values ( %s )',
    join( ', ', @flds ),
    join( ', ', map { '?' } @flds ),
);

my $i = 0;
while ( my $rec = $p->fetchrow_hashref ) {
    $rec->{'species'} ||= $species;
    $dbh->do( $sql, {}, map { $rec->{ $_ } || '' } @flds );
    $i++;
    printf "%-78s\r", sprintf('%3d%%: %s', 
        $i == $lc ? '100' : ($i/$lc) * 100, commify($i)
    );
}

printf "\nDone, loaded %s new records.\n", commify($i);

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-pathway-search.pl - load tab-delimited pathway dump into search dbs

=head1 SYNOPSIS

  load-pathway-search.pl -s arabidopsis -f /path/to/dump.tab

Options:

  -f|--file     The tab-delimited export of pathway data
  -s|--species  The species
  -l|--list     Show a list of valid species
  --force       Don't request confirmation
  --help        Show brief help and exit
  --man         Show full documentation

=head1 DESCRIPTION

Loads the tab-delimited export of pathway data into the 
"<pathway_${species}>" db noted in "gramene.conf."  Will create any
tables needed.  The field names of the tab file must match the field names
of the "search" table, namely:

=over 4

=item * species

=item * gene_name

=item * enzyme_name

=item * reaction_id	

=item * reaction_name

=item * ec	

=item * pathway_id

=back

If "species" is not in the file, then the "species" argument from the 
command line will be used.

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
