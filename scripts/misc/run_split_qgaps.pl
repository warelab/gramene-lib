#!/usr/bin/perl -w
use strict;

my $work_dir = shift @ARGV;
$work_dir ||= ".";

my @psl_files = glob "$work_dir/results/*.psl";

for my $psl (@psl_files) {
    my ($psl_id) = $psl =~ m/results\/(\S+)\.psl$/;
    open( SH, ">", "$work_dir/run/split_$psl_id.sh" )
      or die "failed to open $work_dir/run/split_$psl_id.sh : $!\n";
    print SH qq{#!/bin/sh
cd $work_dir
split_qgaps.pl 10 $psl > $psl.splitted
gzip $psl
rm $psl
};
    close SH;

    system(
"qsub -V -o $work_dir/out/split_$psl_id.stdout -e $work_dir/err/split_$psl_id.stderr -S /bin/sh -cwd $work_dir/run/split_$psl_id.sh"
    );
}

