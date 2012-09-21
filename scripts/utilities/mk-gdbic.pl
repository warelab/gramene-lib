#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw( say );
use autodie;
use Carp qw( croak );
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use File::Basename;
use File::Path qw( mkpath );
use File::Spec::Functions;
use Getopt::Long;
use IO::Prompt qw( prompt );
use Pod::Usage;
use Readonly;
use Grm::Config;
use Grm::DB;

my $out_dir = '';
my $db_name = '';
my $prompt  =  1;
my $debug   =  0;
my ( $help, $man_page );
GetOptions(
    'd|db=s'    => \$db_name,
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

my $config = Grm::Config->new;

if ( !$out_dir ) {
    my $main_conf = $config->get('main');
    my $base_dir  = $main_conf->{'base_dir'} 
        or croak(sprintf('No "base_dir" in conf "%s"'), $config->filename);
    $out_dir = catdir( $base_dir, qw/ lib perl / );
}

if ( !$db_name ) {
    pod2usage('No db name');
}

my $db  = Grm::DB->new( $db_name );
my $dbh = $db->dbh;

if ( $prompt ) {
    my $ok = prompt -yn, sprintf('OK to export "%s" to "%s"? [yn] ',
        $db->real_name, $out_dir
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

my $class = join('::', qw/ Grm DBIC /, 
    join('', map { ucfirst } split( /_/, $db_name ))
);

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
#        { loader_class => 'MyLoader' } # optionally
    ],
);

__END__

# ----------------------------------------------------

=pod

=head1 NAME

mk-gdbic.pl - generate Grm::DBIC classes from the db

=head1 SYNOPSIS

  mk-gdbic.pl -d features 

Required:

  -d|--db     The db symbol in the Gramene config, e.g., "features"

Options:

  -o|--out     The output directory
  -p|--prompt  Prompt or not (can do --no-prompt to suppress
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
