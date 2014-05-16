#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Data::Dump 'dump';
use File::Spec::Functions;
use File::Path 'mkpath';
use Getopt::Long;
use Grm::Config;
use Grm::Utils 'timer_calc';
use Pod::Usage;
use Readonly;

Readonly my $RS => chr(30);
Readonly my $FS => chr(31);

my $out_dir = cwd();
my ( $help, $man_page );
GetOptions(
    'd|dir:s' => \$out_dir,
    'help'    => \$help,
    'man'     => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

if (!-d $out_dir) {
    mkpath($out_dir);
}

my $config = Grm::Config->new;
my @modules = grep { /^pathway/ } $config->get('modules');

for my $module ( @modules ) {
    my $timer = timer_calc();
    my $db    = Grm::DB->new($module);
    my $dbh   = $db->dbh;
    my $data  = $dbh->selectall_arrayref(
        q[
            select search_id, species, gene_name, enzyme_name, reaction_id, 
                   reaction_name, ec, pathway_id, pathway_name
            from   search
        ],
        { Columns => {} }
    );

    (my $species = $module) =~ s/^pathway_//;

    printf "%s: Exporting %s records\n", $module, scalar @$data;
    my $file = catfile($out_dir, $module . '.adt');
    open my $fh, '>', $file;

    print $fh join($FS, qw[id title module object species content]), $RS;

    for my $rec ( @$data ) {
        print $fh join($FS,
            join('/', $module, 'pathway', $rec->{'search_id'}),
            'Pathway ' . $rec->{'pathway_name'},
            $module,
            'pathway',
            $species,
            join(' ', 
                map { defined $rec->{$_} ? $rec->{$_} : () } 
                qw[ gene_name enzyme_name reaction_name ec pathway_id ]
            ),
        ), $RS;
    }
    printf "Finished in %s\n", $timer->();
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

export-pathways.pl - a script

=head1 SYNOPSIS

  export-pathways.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

kclark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
