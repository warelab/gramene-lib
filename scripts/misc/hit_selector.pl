#!/usr/bin/perl -w
use strict;
use GeneScaffold;
use Getopt::Long;

my $scaffolder = new GeneScaffold;

my ( $qlen_file, $tlen_file, $psl );
my %args = (
    'psl'    => \$psl,
    'qlen' => \$qlen_file
);
GetOptions( \%args, 'psl=s', 'qlen=s', $scaffolder->params );
my $arg_str = $scaffolder->args( \%args );
$psl
  or die
"usage:\n$0 $arg_str --psl <input psl file> --qlen <file of qid <tab> length>\n\n";

$scaffolder->init;

open( my $qlen_fh, "<", "$qlen_file" ) or die "failed to open $qlen_file: $!\n";
my @q_names;
while (<$qlen_fh>) {
    chomp;
    my ( $seq_id, $len ) = split /\t/, $_;
    push @q_names, [ $seq_id, $len ];
}
close $qlen_fh;
print STDERR scalar @q_names, " sequences\n";
open(my $psl_fh, "<", $psl) or die "failed to open $psl for reading: $!\n";
for my $sl (@q_names) {
    my ( $seq, $len ) = @$sl;
    my ( $hits, $done ) = $scaffolder->read_hits( $seq, $psl_fh );
    if (@$hits) {
        for
          my $scaffold_range ( @{ $scaffolder->multi_scaffolds( $hits ) } )
        {
            my ( $scaffold, $range ) = @$scaffold_range;
                $scaffolder->print_scaffold($scaffold);
                print STDERR join( "\t",
                    "#COVERAGE", $seq,
                    $scaffolder->coverage($scaffold),
                    $scaffold->[0]{q_size}, @$range ),
                  "\n";
        }
    }
}
close $psl_fh;

exit;

