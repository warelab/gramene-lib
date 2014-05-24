#!/usr/bin/perl -w
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Slice;
use Bio::SeqIO;
use Getopt::Long;
use DBI qw(:sql_types);

my ( $dbname, $dbuser, $dbpass, $dbhost, $dbport, $slices, $outfile );

GetOptions(
    'dbhost=s' => \$dbhost,
    'dbport=s' => \$dbport,
    'dbuser=s' => \$dbuser,
    'dbpass=s' => \$dbpass,
    'dbname=s' => \$dbname,
    'slices=s' => \$slices,
	'outfile=s' => \$outfile
) or die "GetOptions() failure: $!\n";

my $dba = Bio::EnsEMBL::DBSQL::DBAdaptor->new(
    -user   => $dbuser,
    -pass   => $dbpass,
    -dbname => $dbname,
    -host   => $dbhost,
    -port   => $dbport,
    -driver => 'mysql'
);

my $slice_adaptor = $dba->get_adaptor('Slice');

my $seq_out = Bio::SeqIO->new(-file => ">$outfile", -format => 'fasta');
$seq_out->width(80);
open( my $fh, "<", $slices ) or die "failed to open $slices for reading: $!\n";
while (<$fh>) {
    chomp;
	my ($cs,$ver,$name,$start,$end,$ori) = split /:/, $_;

	my $slice = $slice_adaptor->fetch_by_region(undef, $name, $start, $end);
	$slice = $slice->get_repeatmasked_seq(['TEConsortium','TEConsortiumLTR','RepeatMask'],1);
	$seq_out->write_seq($slice);
}
close $fh;
exit;

