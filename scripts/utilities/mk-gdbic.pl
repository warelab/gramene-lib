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
use Readonly;

if ( !@ARGV ) {
    pod2usage('No arguments, perhaps use "-l" to list dbs?');
}

my $out_dir   = '';
my $db_names  = '';
my $make_all  =  0;
my $prompt    =  1;
my $debug     =  0;
my $show_list =  0;
my ( $help, $man_page );
GetOptions(
    'all'       => \$make_all,
    'd|db=s'    => \$db_names,
    'l|list'    => \$show_list,
    'o|out:s'   => \$out_dir,
    'p|prompt!' => \$prompt,
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
    say join "\n", 'Valid module:', map { " - $_" } @modules;
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

if ( $prompt ) {
    my $ok    = prompt -yn, sprintf('OK to export "%s" to "%s"? [yn] ',
        join(', ', @dbs), $out_dir
    );

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

for my $db_name ( @dbs ) {
    my $db    = Grm::DB->new( $db_name );
    my $class = join('::', qw/ Grm DBIC /, 
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
            $db->dsn,
            $db->user,
            $db->password,
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
  -p|--prompt  Prompt or not (can do --no-prompt to suppress
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
