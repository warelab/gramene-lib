#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw( say );
use autodie;
use Carp qw( croak );
use DBIx::Class::Schema::Loader qw( make_schema_at );
use File::Basename;
use File::Path qw( mkpath );
use File::Spec::Functions;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use IO::Prompt qw( prompt );
use Pod::Usage;
use Perl6::Slurp qw( slurp );
use Readonly;
use SQL::Translator;

if ( !@ARGV ) {
    pod2usage('No arguments, perhaps use "-l" to list dbs?');
}

my $db_names  = '';
my $debug     =  0;
my $make_all  =  0;
my $out_dir   = '';
my $show_list =  0;
my $force     =  0;
my ( $help, $man_page );
GetOptions(
    'all'       => \$make_all,
    'd|db=s'    => \$db_names,
    'f|force'   => \$force,
    'l|list'    => \$show_list,
    'o|out:s'   => \$out_dir,
    'debug'     => \$debug,
    'help'      => \$help,
    'man'       => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $config  = Grm::Config->new;
my @modules = $config->get('modules');

if ( $show_list ) {
    say join "\n", 'Valid module:', map { " - $_" } sort @modules;
    exit 0;
}

if ( !$out_dir ) {
    my $base_dir  = $config->get('base_dir')
        or croak(sprintf('No "base_dir" in conf "%s"'), $config->filename);
    $out_dir = catdir( $base_dir, 'lib' );
}

if ( !$db_names && !$make_all ) {
    pod2usage('No db name(s)');
}

my @dbs = $make_all ? @modules : split( /\s*,\s*/, $db_names );
my %is_valid = map { $_, 1 } @modules;

if ( my @bad = grep { !$is_valid{ $_ } } @dbs ) {
    die "Invalid modules: ", join(', ', @bad), "\n";
}

unless ( $force ) {
    my $ok = prompt -yn, 
        sprintf("OK to export to '%s' the following?\n%s\n [yn] ",
            $out_dir,
            join( "\n", map { " - $_" } @dbs ), 
        )
    ;

    if ( !$ok ) {
        say 'Bye.';
        exit 0;
    }
}

if ( -e $out_dir ) {
    if ( !-d $out_dir ) {
        croak("Out dir '$out_dir' is not a directory");
    }
}
else {
    mkpath( $out_dir );
}

my %seen;
DB:
for my $db_name ( @dbs ) {
    my $db    = Grm::DB->new( $db_name );
    my $dsn   = $db->dsn;
    my $user  = $db->user;
    my $pass  = $db->password;
    my $host  = $db->host;
    my $class = '';

    if ( $db_name =~ /^ensembl_/ && $db->real_name =~ /core/ ) {
        next DB if $host eq 'ensembldb.ensembl.org'; 

        $db_name = 'ensembl';

        next DB if $seen{ $db_name }++;

        my $tmp_db_name = '_ensembl_gcdbi_build';
        $db->dbh->do("drop database if exists $tmp_db_name");
        $db->dbh->do("create database $tmp_db_name");

        $dsn = "dbi:mysql:host=$host;database=$tmp_db_name";
        my $build_db = DBI->connect( $dsn, $user, $pass, { RaiseError => 1 } );

        my $ensembl_sql = catfile( 
            $config->get('base_dir'), 'schemas', 'ensembl', 'ensembl-innodb.sql'
        );

        my $sql = '';
        if ( -e $ensembl_sql ) {
            $sql = slurp( $ensembl_sql );
        }
        else {
            my $ens_conf = $config->get('ensembl') 
                           or die "No Ensembl config\n";;

            my $tmp = '';
            for my $file ( qw[ sql_file ] ) { # foreign_key_file 
                my $path = $ens_conf->{ $file } or next;

                if ( -e $path ) {
                    $tmp .= slurp( $path );
                }
            }

            if ( !$tmp ) {
                die "Did not get any SQL from Ensembl config\n";
            }

            $tmp =~ s/MyISAM/InnoDB/gi;
            $tmp =~ s!/\*([^*]|\*[^/])*\*/!!g;
            $tmp =~ s/collate=\w+//gi;
            $tmp =~ s/"/'/gi;
            $tmp =~ s/(small)?int(eger)(\d+) unsigned/integer unsigned/gi;

            my $sqlt = SQL::Translator->new;

            my $sql  = $sqlt->translate(
                from           => 'MySQL',
                to             => 'MySQL',
                data           => \$tmp,
                add_drop_table => 1,
                directed       => 1,
            );
        }

        if ( !$sql ) {
            die "Can't find any SQL to create Ensembl schema.\n";
        }

        for my $cmd ( split( /;/, $sql ) ) {
            next if !$cmd || $cmd =~ /^\s*$/;
            $build_db->do( $cmd );
        }

        $db = $build_db;
    }
    elsif ( $db_name =~ /^(diversity|pathway)_/ ) {
        $db_name = $1;
        next DB if $seen{ $db_name }++;
    }

    $class = join('::', qw/ Grm DBIC /, 
        join('', map { ucfirst } split( /_/, $db_name ))
    );

    print "Exporting $db_name => $class\n";

    make_schema_at(
        $class,
        { 
            debug          => $debug,
            dump_directory => $out_dir,
            use_moose      => 1,
        },
        [ 
            $dsn ,
            $user,
            $pass,
        ],
    );

    print '-' x 40, "\n";
}

my $num = scalar @dbs;
printf "Done, exported %s database%s\n", $num, $num == 1 ? '' : 's';

__END__

# ----------------------------------------------------

=pod

=head1 NAME

mk-gdbic.pl - generate Grm::DBIC classes from the db

=head1 SYNOPSIS

  mk-gdbic.pl -d features 


Options:

  --all        Make for all databases
  -d|--db      A comma-separated list of database symbols 
               in the Gramene config, e.g., "maps"
  -o|--out     The output directory
  -f|--force   Do not prompt 
  -l|--list    Show a list of the valid modules/dbs
  --debug      Debug flag
  --help       Show brief help and exit
  --man        Show full documentation

=head1 DESCRIPTION

Reads the specified schema and creates a Gramene - DBIx::Class 
(Grm::DBIC) class.

=head1 SEE ALSO

DBIx::Class.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2011 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
