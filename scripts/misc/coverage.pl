#!/usr/bin/perl -w
use strict;
use GeneScaffold;
use Getopt::Long;

my $scaffolder = new GeneScaffold;

my ($psl);
my %args = ( 'psl' => \$psl );
GetOptions( \%args, 'psl=s', $scaffolder->params );
my $arg_str = $scaffolder->args( \%args );
$psl or die "usage:\n$0 $arg_str --psl file.psl\n\n";

$scaffolder->init;

my $fh;
open( $fh, "<", $psl ) or die "failed to open $psl for reading : $!\n";
while ( my $hits = $scaffolder->read_next($fh) ) {
    print join( "\t",
        $hits->[0]{q_name},
        $hits->[0]{q_size},
        $scaffolder->coverage($hits) ),
      "\n";
}
close $fh;
