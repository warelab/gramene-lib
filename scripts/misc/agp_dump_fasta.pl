#!/usr/bin/perl -w
use strict;

use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Slice;
use Getopt::Long;

my ( $dbname, $dbuser, $dbpass, $dbhost, $dbport, $outfa, $outagp );

GetOptions(
    'dbhost=s' => \$dbhost,
    'dbport=s' => \$dbport,
    'dbuser=s' => \$dbuser,
    'dbpass=s' => \$dbpass,
    'dbname=s' => \$dbname,
    'outfa=s'  => \$outfa,
    'outagp=s' => \$outagp
) or die;

my $dba = Bio::EnsEMBL::DBSQL::DBAdaptor->new(
    -user   => $dbuser,
    -pass   => $dbpass,
    -dbname => $dbname,
    -host   => $dbhost,
    -port   => $dbport,
    -driver => 'mysql'
);

my $sa = $dba->get_SliceAdaptor();

my @chr_order =
  ( 6, 'mitochondrion', 3, 7, 9, 2, 8, 1, 4, 'chloroplast', 10, 'UNKNOWN', 5 );

my $curr = 0;
my $next = 1;
open( my $fafh, ">", $outfa ) or die "failed to open $outfa for writing: $!\n";
open( my $agpfh, ">", $outagp )
  or die "failed to open $outagp for writing: $!\n";
print $fafh ">$chr_order[$curr]\n";
my $pos = 0;
my $n   = 0;
my $mod = 0;
my $ll  = 60;
while (<>) {
    next if /^#/;
    $n++;
    chomp;
    my @x = split /\t/, $_;
    if ( $next < @chr_order and $x[0] eq $chr_order[$next] ) {
        $curr++;
        $next++;
		print $fafh "\n" if ($mod);
        print $fafh ">$chr_order[$curr]\n";
        $pos = 0;
        $n   = 0;
        $mod = 0;
    }
    if ( $x[4] eq 'N' ) {
        print $agpfh join( "\t",
            $chr_order[$curr], $pos + 1, $pos + $x[5],
            $n, 'N', $x[5], $x[6], $x[7],, 'NA' ),
          "\n";
        write_seq( 'N' x $x[5] );    # <------ write_seq() updates $pos and $mod
    }
    else {
        print $agpfh join( "\t",
            $chr_order[$curr], $pos + 1, $pos + $x[7] - $x[6] + 1,
            $n, 'D', $x[5], $x[6], $x[7], $x[8], $x[9] ),
          "\n";
        my $slice;
        if ( $x[5] =~ m/^k/ ) {
            $slice =
              $sa->fetch_by_region( 'contig', $x[5], $x[6], $x[7],
                $x[8] eq '+' ? 1 : -1 );
        }
        else {
            $slice =
              $sa->fetch_by_region( 'clone', $x[5], $x[6], $x[7],
                $x[8] eq '+' ? 1 : -1 );
        }
        write_seq( $slice->seq() );
    }
}

close $fafh;
close $agpfh;
exit;

sub write_seq {
    my $seq = shift;

    # params
    # $pos = current position in pseudomolecule
    # $ll  = desired line length (60)
    # $mod = previous value for $pos % $ll

    my $seqlen = length $seq;
    my $offset = 0;
    my $length = $ll - $mod;
    while ( $offset < $seqlen ) {
        my $ss = substr( $seq, $offset, $length );
        print $fafh $ss;
        print $fafh "\n" if ( length($ss) == $length );
        $offset += $length;
        $length = $ll;
    }
    $pos += $seqlen;
    $mod = $pos % $ll;
}
