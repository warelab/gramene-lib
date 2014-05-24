#!/usr/bin/perl -w
use strict;
use GeneScaffold;
use Getopt::Long;

my $scaffolder = new GeneScaffold;

my ( $work_dir, $add_psl, $i, $flip_file );
my %args = (
    'i'    => \$i,
    'work' => \$work_dir,
    'add'  => \$add_psl,
    'flip' => \$flip_file
);
GetOptions( \%args, 'work=s', 'add=s', 'i=i', 'flip=s', $scaffolder->params );
my $arg_str = $scaffolder->args( \%args );
$work_dir
  or die
"usage:\n$0 $arg_str --work . --add ../blat_vs_RefGen_v2/out/merge__REPLACE_.stdout --i 2 --flip cDNAs2flip.txt\n\n";

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

my @db_files = glob "$work_dir/split_d/*.2bit";
@db_files or @db_files = glob "$work_dir/split_d/*.fa";
my $n_db = @db_files;

my $in = "$work_dir/split_i/$i.2bit";
my $in_fh;
if ( -e $in ) {
    open( $in_fh, "-|", "/home/ware/chia/src/blat/twoBitInfo $in /dev/fd/1" )
      or die "failed to run twoBitInfo $in /dev/fd/1\n";
}
else {
    $in = "$work_dir/split_i/$i.fa";
    open( $in_fh, "-|", "find_lengths.pl $in" )
      or die "failed to run find_lengths.pl $in\n";
}
my @q_names;
while (<$in_fh>) {
    chomp;
    my ( $seq_id, $len ) = split /\t/, $_;
    push @q_names, [ $seq_id, $len ];
}
close $in_fh;
print STDERR scalar @q_names, " sequences\n";
my %psl_fh;
for ( my $j = 1 ; $j <= @db_files ; $j++ ) {
    my $psl = "$work_dir/results/${i}_vs_$j.psl";
    if ( not -e "$psl.splitted" ) {
        if ( -e "$psl.splitted.gz" ) {
            print STDERR "gzip -d $psl.splitted.gz";
            system("gzip -d $psl.splitted.gz");
            print STDERR " done\n";
        }
        else {
            print STDERR "split_qgaps.pl 10 $psl > $psl.splitted";
            system("split_qgaps.pl 10 $psl > $psl.splitted");
            print STDERR " done\n";
        }
    }
    my $fh;
    open( $fh, "<", "$psl.splitted" )
      or die "failed to open $psl.splitted for reading : $!\n";
    $psl_fh{$j} = $fh;
}

# add the additional psl file
if ($add_psl) {
    $add_psl =~ s/_REPLACE_/$i/;
    if ( -e $add_psl ) {
        my $fh;
        open( $fh, "<", $add_psl )
          or die "failed to open $add_psl : $!\n";
        $psl_fh{extra} = $fh;
    }
    else {
        die "file not found: $add_psl\n";
    }
}
for my $sl (@q_names) {
    my ( $seq, $len ) = @$sl;
    my @all_hits;
    while ( my ( $psl, $fh ) = each %psl_fh ) {
        my ( $hits, $done ) = $scaffolder->read_hits( $seq, $fh );
        if (@$hits) {
            if ( exists $flipme{ $hits->[0]{q_name} } ) {
                $hits = $scaffolder->reverse_complement($hits);
            }
            push @all_hits, @$hits;
        }
        if ($done) {
            close $fh;
            delete $psl_fh{$psl};
        }
    }
    if (@all_hits) {
        for
          my $scaffold_range ( @{ $scaffolder->multi_scaffolds( \@all_hits ) } )
        {
            my ( $scaffold, $range ) = @$scaffold_range;
            if ( $args{dump_gaps} ) {
                $scaffolder->dump_gaps( $seq, $len, $scaffold );
            }
            elsif ( $args{softmask} ) {
                $scaffolder->dump_softmasked( $seq, $len, $scaffold );
            }
            else {
                $scaffolder->print_scaffold($scaffold);
                print STDERR join( "\t",
                    "#COVERAGE", $seq,
                    $scaffolder->coverage($scaffold),
                    $scaffold->[0]{q_size}, @$range ),
                  "\n";
            }
        }
    }
    elsif ( $args{dump_gaps} ) {
        $scaffolder->dump_gaps( $seq, $len, [] );
    }
    elsif ( $args{softmask} ) {
        $scaffolder->dump_softmasked( $seq, $len, [] );
    }
}
while ( my ( $psl, $fh ) = each %psl_fh ) {
    close $fh;
}

exit;

