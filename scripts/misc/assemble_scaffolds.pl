#!/usr/bin/perl -w
use strict;
use GeneScaffold;
use Getopt::Long;

my $scaffolder = new GeneScaffold;

my ( $out_dir, $do_graphs, $in_file, $flip_file );
my %args = (
    'in'        => \$in_file,
    'outdir'    => \$out_dir,
    'do_graphs' => \$do_graphs,
    'flip'      => \$flip_file
);
GetOptions( \%args, 'do_graphs', 'outdir=s', 'in=s', 'flip=s',
    $scaffolder->params );
my $arg_str = $scaffolder->args( \%args );
$in_file
  or die
"usage:\n$0 $arg_str --outdir . --in in.psl --do_graphs --flip cDNAs2flip.txt\n\n";

$scaffolder->init;

my %flipme;
if ($flip_file) {
    open( my $flip_fh, "<", $flip_file )
      or die "failed to open $flip_file for reading: $!\n";
    while (<$flip_fh>) {
        chomp;
        $flipme{$_} = 1;
    }
    close $flip_fh;
}

open( my $psl_fh, "<", $in_file )
  or die "failed to open $in_file for reading : $!\n";

while ( my $hits = $scaffolder->read_next($psl_fh) ) {
    if ( exists $flipme{ $hits->[0]{q_name} } ) {
        $hits = $scaffolder->reverse_complement($hits);
    }
    $hits = $scaffolder->filter_scaffold_hits($hits);
    if (@$hits) {
        $scaffolder->add_scaffold_to_graph( fix_hits($hits) );
    }
}
close $psl_fh;

$scaffolder->place_scaffolds();
if ($do_graphs) {
    $scaffolder->output_graph($out_dir);
}
$scaffolder->output_agp();

exit;

sub fix_hits {
    my $hits = shift;
    my @sorted = sort { $a->{q_start} <=> $b->{q_start} } @$hits;
    for my $hit (@sorted) {
        $hit->{strand} = $hit->{strand} eq '+' ? 1 : -1;
    }
    return \@sorted;
}
