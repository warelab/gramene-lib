#!/usr/bin/perl -w
use strict;
use GeneScaffold;

use Getopt::Long;

my $scaffolder = new GeneScaffold;

my $work_dir;
my $add_psl;
my %args = ( 'work' => \$work_dir, 'add' => \$add_psl );

GetOptions( \%args, 'work=s', 'add=s', $scaffolder->params );
my $scaffolder_args = $scaffolder->args( \%args );

$work_dir
  or die
  "usage:\n$0 --work . --add ../blat_vs_RefGen_v2/out/merge__REPLACE_.stdout "
  . $scaffolder->args . "\n\n";

my @in_files = glob "$work_dir/split_i/*.2bit";
@in_files or @in_files = glob "$work_dir/split_i/*.fa";
for ( my $i = 1 ; $i <= @in_files ; $i++ ) {

    my $cmd = "psl_combiner.pl -work $work_dir -i $i $scaffolder_args";
    $cmd .= " -add $add_psl" if $add_psl;

    open( SH, ">", "$work_dir/run/merge_$i.sh" )
      or die "failed to open $work_dir/run/merge_$i.sh : $!\n";
    print SH "#!/bin/sh\ncd $work_dir\n$cmd\n";
    close SH;

    system(
"qsub -V -l virtual_free=1.8G -o $work_dir/out/merge_$i.stdout -e $work_dir/err/merge_$i.stderr -S /bin/sh -cwd $work_dir/run/merge_$i.sh"
    );
}

