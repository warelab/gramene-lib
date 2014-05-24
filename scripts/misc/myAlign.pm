package myAlign;

use strict;

my $tmpdir = "/dev/shm";

my @PSL = (
    'match',       'mismatch',    'rep_match',   'Ns',
    'q_gap_count', 'q_gap_bases', 't_gap_count', 't_gap_bases',
    'strand',      'q_name',      'q_size',      'q_start',
    'q_end',       't_name',      't_size',      't_start',
    't_end',       'block_count', 'blockSizes',  'qStarts',
    'tStarts'
);

sub new {
    my $name  = shift;
    my $class = ref($name) || $name;
    my $this  = {};
    bless $this, $class;
    return $this;
}

sub blat2seqs {
    my ( $this, $seq1, $seq2 ) = @_;
    my $f1 = "$tmpdir/1_$$.fa";
    my $f2 = "$tmpdir/2_$$.fa";
    open( OUT, ">", $f1 ) or die "failed to open $f1 for writing: $!\n";
    print OUT ">s\n$seq1\n";
    close OUT;
    open( OUT, ">", $f2 ) or die "failed to open $f2 for writing: $!\n";
    print OUT ">t\n$seq2\n";
    close OUT;
    my $cmd = "blat -noHead -fastMap $f2 $f1 /dev/fd/1";
    open( BLAT, "$cmd |" ) or die "failed to run $cmd: $!\n";
    my @hits;

    while (<BLAT>) {
        /^[0-9]/ or next;
        chomp;
        my %hit;
        my @c = split /\t/, $_;
        for ( my $i = 0 ; $i < @c ; $i++ ) {
            $hit{ $PSL[$i] } = $c[$i];
        }
        push @hits, \%hit;
    }
    close BLAT;
    unlink $f1;
    unlink $f2;
    return @hits ? \@hits : undef;
}

1;
