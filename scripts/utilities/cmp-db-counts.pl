#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use English qw( -no_match_vars );
use File::Basename;
use File::Spec::Functions;
use Getopt::Long;
use Grm::Config;
use Grm::Utils qw( commify );
use List::MoreUtils qw( uniq );
use List::Util qw( max );
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

$| = 1;

Readonly my $EMPTY_STR => q{};

my $user       = $EMPTY_STR;
my $pass       = $EMPTY_STR;
my $host       = $EMPTY_STR;
my $skip       = $EMPTY_STR;
my $show_lower = $EMPTY_STR;
my $compare    = 1;
my $check_only_common = 0;
my ( $help, $man_page );
GetOptions(
    'u|user:s' => \$user,
    'p|pass:s' => \$pass,
    's|skip:s' => \$skip,
    'h|host:s' => \$host,
    'compare!' => \$compare,
    'lower'    => \$show_lower,
    'common'   => \$check_only_common,
    'help'     => \$help,
    'man'      => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my @dsns = @ARGV or pod2usage('No DSNs');
if ( scalar @dsns < 1 ) {
    pod2usage('Need 1-2 DSNs');
}

if ( !$user || !$pass ) {
    if ( my $home = $ENV{'HOME'} || (getpwuid($<))[7] ) {
        my $mysql_conf = catfile( $home, '.my.cnf' );
        if ( -e $mysql_conf ) {
            open my $cnf, '<', $mysql_conf; # no die

            my $ok = 0;
            if ( $cnf ) {
                while ( my $line = <$cnf> ) {
                    chomp $line;
                    $ok ||= $line !~ /^\[client\]/;
                    next if !$ok;

                    if ( $line =~ /user=(.+)/ ) {
                        $user = $1;
                    }
                    elsif ( $line =~ /password=(.+)/ ) {
                        $pass = $1;
                    }

                    last if $user && $pass;
                } 
            }
        }
    }
}

if ( !$user || !$pass ) {
    pod2usage('Need db user name and password');
}

$compare         = defined $show_lower ? $show_lower : $compare;
my @skip         = split /,\s*/, $skip;
my $config       = Grm::Config->new;
my @modules      = $config->get('modules');
my %valid_module = map { $_, 1 } @modules;

my %seen;
my @dbs;
DSN:
for my $dsn ( @dsns ) {
    my ( $db_name, $dbh );

    if ( $valid_module{ $dsn } ) {
        $dbh     = Grm::DB->new( $dsn );
        $db_name = $dsn;
    }
    elsif ( $dsn =~ /^dbi:\w+:(.+)/ ) {
        my $s = $1; 
        if ( $s =~ /database=(.+)/ ) {
            $db_name = $1;
        }
        else {
            $db_name = $s;
        }
    }
    else {
        $db_name = $dsn;
        $dsn     = 'dbi:mysql:' . join(';', 
            map { $_ || () } 
            "database=$dsn", 
            $host ? "host=$host" : $EMPTY_STR
        );
    }

    if ( $seen{ $dsn }++ ) {
        print "$db_name is duplicated, skipping.\n";
        next DSN;
    }

    if ( !$dbh ) {
        $dbh = DBI->connect( $dsn, $user, $pass, { RaiseError => 1 } );
    }

    push @dbs, { name => $db_name, dbh => $dbh };
}

if ( scalar @dbs < @dsns ) {
    die "Didn't connect to enough dbs.\n";
}

my ( %count, %count_by_db );
for my $db ( @dbs ) {
    my $db_name    = $db->{'name'};
    my $dbh        = $db->{'dbh'};
    my @tables     = @{ $dbh->selectcol_arrayref('show tables') }; 
    my $num_tables = scalar @tables;

    my $i;
    for my $table ( @tables ) {
        my $num_dots = int( ++$i / $num_tables ) * 100;
        print 'Counting ', '.' x $num_dots, "\r";
        my $c = $dbh->selectrow_array("select count(*) from $table");
        $count{ $table }{ $db_name } = $c;
        push @{ $count_by_db{ $db_name } }, commify( $c );
    } 
}

my %max_table_count_by_db;
for my $db_name ( keys %count_by_db ) {
    $max_table_count_by_db{ $db_name } 
        = max( map { length } @{ $count_by_db{ $db_name } } );
}

my @db_names = sort map { $_->{'name'} } @dbs;
my @cols     = ( 'Table', ( sort map { $_->{'name'} } @dbs ) );
my $show_cmp = 0;
if ( @dbs > 1 && $compare ) {
    push @cols, $show_lower ? 'Lower?' : 'Bad?';
    $show_cmp = 1;
}

my $tab = Text::TabularDisplay->new( @cols );

my $num_errors = 0;
TABLE:
for my $table ( sort keys %count ) {
    for my $skip ( @skip ) {
        next TABLE if $table =~ /$skip/;
    }

    my ( @counts, @formatted_counts );
    for my $db_name ( @db_names ) {
        my $count
            = defined $count{ $table }{ $db_name }
            ? $count{ $table }{ $db_name }
            : '-'
        ;

        if ( $check_only_common && $count eq '-' ) {
            next TABLE;
        }

        push @counts, $count;
        my $len = max(
            length( $db_name ), $max_table_count_by_db{ $db_name } || 0
        );
        push @formatted_counts, sprintf( "%${len}s", commify($count) );
    }

    my $bad = $EMPTY_STR;
    if ( uniq( @counts ) > 1 ) {
        if ( $show_lower ) {
            if ( $counts[-1] < $counts[0] ) {
                $bad = 'Lower';
            }
        }
        else {
            $bad = 'Bad';
        }
    }

    $tab->add( $table, @formatted_counts, $show_cmp ? $bad : () );
    $num_errors++ if $bad;
}

print join( "\n", 
    $EMPTY_STR, 
    $tab->render, 
    $show_cmp 
        ? sprintf( 'Found %s error%s.', 
            $num_errors, $num_errors == 1 ? $EMPTY_STR : 's' 
        )
        : $EMPTY_STR,
    $EMPTY_STR
);

__END__

# ----------------------------------------------------

=pod

=head1 NAME

cmp-db-counts.pl - a script

=head1 VERSION

This documentation refers to version $Revision: 16136 $

=head1 SYNOPSIS

  cmp-db-counts.pl [options] dsn1 dsn2 [...]

Options:

  -h|--host     DB host
  -u|--user     DB user name for connection
  -p|--pass     DB password
  -s|--skip     Comma-separated list of tables (or regexes) to skip
  --compare     Compare the tables (default yes, --no-compare to skip)
  --lower       Mark tables lower in second db (default no)
  --common      Only check tables in common
  --help        Show brief help and exit
  --man         Show full documentation
  --version     Show version and exit

=head1 DESCRIPTION

Pass either full DSNs or just db names.

=head1 SEE ALSO

DBI.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2008 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
