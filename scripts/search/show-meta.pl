#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Grm::Search;
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

my $modules   = '';
my $show_list = 0;
my ( $help, $man_page );
GetOptions(
    'l|list'      => \$show_list,
    'm|module:s'  => \$modules,
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 


my $search  = Grm::Search->new;
my @modules = $search->search_dbs;

if ( $show_list ) {
    print join "\n",
        'Valid modules:',
        ( map { " - $_" } @modules ),
        '',
    ;
    exit 0;
}

my @do_modules = map { $_, 1 } split /\s*,\s*/, $modules;

my %all_meta;
for my $module ( @modules ) {
    if ( @do_modules ) {
        my $skip = 1;
        for my $do ( @do_modules ) {
            if ( $module =~ /$do/ ) {
                $skip = 0;
                last;
            }
        }

        next if $skip;
    }

    my $dbh = $search->connect_mysql_search_db( $module );
    $all_meta{ $module } = {
        map { @$_ }
        @{$dbh->selectall_arrayref( 'select meta_name, meta_value from meta' )}
    };
}

if ( %all_meta ) {
    my %keys;
    for my $module ( keys %all_meta ) {
        map { $keys{ $_ }++ } keys $all_meta{ $module };
    }

    my @keys = sort keys %keys;
    my $tab = Text::TabularDisplay->new( 'module', @keys );

    for my $module ( sort keys %all_meta ) {
        $tab->add( $module, map { $all_meta{ $module }{ $_ } } @keys );
    }

    say $tab->render, '';
}
else {
    say 'No meta.'
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

show-meta.pl - a script

=head1 SYNOPSIS

  show-meta.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

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
