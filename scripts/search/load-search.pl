#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
use File::Basename qw( basename );
use File::Find::Rule;
use File::Spec::Functions qw( catdir );
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Search;
use Grm::Ontology;
use Grm::Utils qw( camel_case commify timer_calc );
use HTML::Strip;
use IO::Prompt qw( prompt );
use List::MoreUtils qw( uniq );
use Lucy::Analysis::PolyAnalyzer;
use Lucy::Index::Indexer;
use Lucy::Plan::FullTextType;
use Lucy::Plan::Schema;
use Pod::Usage;
use Readonly;
use Time::HiRes qw( gettimeofday tv_interval );
use Time::Interval qw( parseInterval );


my $force         =  0;
my $load_all      =  0;
my $load_like     = '';
my $load_not_like = '';
my $skip_done     =  0;
my $show_list     =  0;
my $modules       = '';
my ( $help, $man_page );
GetOptions(
    'a|all'      => \$load_all,
    'l|list'     => \$show_list,
    'f|force'    => \$force,
    'like:s'     => \$load_like,
    'not-like:s' => \$load_not_like,
    'm|module:s' => \$modules,
    'skip-done'  => \$skip_done,
    'help'       => \$help,
    'man'        => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $search_db  = Grm::Search->new;
my $gconf      = Grm::Config->new;
my $index_path = $search_db->index_path or die "No index_path\n";
my @modules    = $gconf->get('modules');
my $sconf      = $gconf->get('search');


if ( $show_list ) {
    print join "\n",
        'Valid modules:',
        ( map { " - $_" } @modules ),
        '',
    ;
    exit 0;
}

if ( $load_like && $load_not_like ) {
    pod2usage("Don't use both --like and --not-like");
}

my @do_modules;
if ( $modules ) {
    @do_modules = split /\s*,\s*/, $modules;
}
elsif ( $load_like ) {
    for my $like ( split( /\s*,\s*/, $load_like ) ) {
        push @do_modules, grep { /$like/ } @modules;
    }
}
elsif ( $load_not_like ) {
    for my $not_like ( split( /\s*,\s*/, $load_not_like ) ) {
        push @do_modules, grep { !/$not_like/ } @modules;
    }
}
elsif ( $load_all ) {
    @do_modules = @modules;
}

if ( $skip_done ) {
    my %done = map { basename($_), 1 } 
      File::Find::Rule->directory()->nonempty->maxdepth(1)->mindepth(1)
        ->in($index_path);

    @do_modules = grep { !$done{ $_ } } @do_modules;

    if ( !@do_modules ) {
        print join("\n",
            'Looks all modules are up-to-date.',
            'Either remove directories you want reprocessed ',
            "or don't use --skip-done.",
        );
        exit 0;
    }
}

if ( !@do_modules ) {
    pod2usage('Please indicate the modules or choose --all');
}

unless ( $force ) {
    my $ok = prompt -yn, 
        sprintf("OK to load the following?\n%s\n[yn] ", 
            join("\n", map { " - $_" } @do_modules)
        )
    ;

    if ( !$ok ) {
        print "Not OK, exiting.\n";
        exit 0;
    }
}

my ( $num_modules, $num_tables, $num_records ) = ( 0, 0, 0 );
my $total_timer = timer_calc();

MODULE:
for my $module ( uniq( @do_modules ) ) {
    next MODULE if $module eq 'search';

    my $results = $search_db->index( 
        module  => $module,
        verbose => 1,
    );

    $num_modules++;

    $num_tables  += $results->{'num_tables'};
    $num_records += $results->{'num_records'};
}

printf "Done processing %s record%s in %s table%s in %s module%s in %s.\n",
    $num_records,
    $num_records == 1 ? '' : 's',
    $num_tables,
    $num_tables  == 1 ? '' : 's',
    $num_modules,
    $num_modules == 1 ? '' : 's',
    $total_timer->(),
;

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-search.pl - load Apache::Lucy search index for Gramene

=head1 SYNOPSIS

  load-search.pl [options]

Options:

  -a|--all     Process all modules
  -f|--force   Don't prompt for confirmation
  -l|--list    Show a list of modules
  --like       Comma-separated list of regexes to select modules
  --not-like   Comma-separated list of regexes to deselect modules
  -m|--module  Comma-separated list of modules to index
  --skip-done  Skip previously indexed modules (useful w/other selectors)

  --help       Show brief help and exit
  --man        Show full documentation

=head1 DESCRIPTION

Processes the modules indicated, indexing them for the Gramene search.

=head1 SEE ALSO

Apache::Lucy.

=head1 AUTHOR

Adapted from "indexer.pl" from the Apache Lucy sample Perl script by
Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
