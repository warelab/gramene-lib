#!/usr/local/bin/perl

# script to dump out all genes, transcripts, exons, introns, cdses from all gramene ensembl databases.
# pulls out all databases from the gramene config file that start with ensembl_ and are hosted on cabot.
# Specify the output directory with --output_dir=/path/to/output. Defaults to /tmp.

use lib '/usr/local/gramene/lib/perl';
use lib '/usr/local/gramene-svn-2/ensembl-plugins/maize/modules';
use lib '/usr/local/gramene-cvs/ensembl-plugins/maize/modules/';

use lib map { "/usr/local/ensembl-live/$_" } qw ( bioperl-live modules ensembl/modules ensembl-external/modules ensembl-draw/modules ensembl-compara/modules ensembl-variation/modules/ gramene-live/ensembl-plugins/gramene/modules gramene-live/ensembl-plugins/maize/modules conf);

use strict;
use warnings;
use ExportView::GFF3Exporter;
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Getopt::Long;
use Bio::EnsEMBL::Registry;

my %args = (
	'output_dir' => '/tmp',
	'registry' => '/usr/local/gramene-ensembl/conf/ensembl.registry',
);

GetOptions(
	\%args,
	'output_dir=s',
	'registry=s',
);

Bio::EnsEMBL::Registry->load_all($args{'registry'});
my @db_adaptors = @{ Bio::EnsEMBL::Registry->get_all_DBAdaptors() };

print STDERR "Sending files to $args{'output_dir'}\n\n";

open my $blammofh, ">", "/home/thomason/blammo.log" or die $!;
use IO::Handle; $blammofh->autoflush(1);

foreach my $db (@db_adaptors) {

	next unless $db->dbc->host eq 'cabot';	#assume gramene dbs are only on cabot

    my $key = lc $db->species;
    my $dbname = $db->dbc->dbname;
#print STDERR "DBNAME : $dbname\n";
#print "KEY IS $key\n";
print STDERR "DUMPING $dbname\n";

    next unless $db->group eq 'core';
print STDERR "...still dumping\n";
    my $output_file = $args{'output_dir'} . '/' . $key . ".gff";

    eval {
	    my $tdba = Bio::EnsEMBL::DBSQL::DBAdaptor->new(
                               -user   => $db->dbc->username,
                               -pass   => $db->dbc->password,
                               -dbname => $dbname,
                               -host   => $db->dbc->host,
                               -port    => '3306',
                               -driver  => 'mysql',
                               );

        my $adaptor = $tdba->get_SliceAdaptor;
    
	    my $slices = $adaptor->fetch_all('toplevel');
    
    
	    print STDERR "\tDumping $key ($dbname) to $output_file (" , scalar(@$slices), " slices)\n";
    
	    open (my $gff, '>' . $output_file);

	    my $exporter = ExportView::GFF3Exporter->new('debug' => 1);
	    $exporter->header($gff, $adaptor->db->get_MetaContainer->get_Species()->common_name(), $adaptor->db->get_MetaContainer->get_genebuild());
    	$exporter->export_genes_from_slices($gff, @$slices);
    	#$exporter->export_genes_from_slices(\*STDERR, @$slices);


        close $gff;
    };

    if ($@) {
    	unlink $output_file;
    	print STDERR "BLAMMO! DUMP FAILED: $@. Deleting log!\n";
    	print $blammofh "BLAMMO! DUMP FAILED: $@. Deleting log!\n";
    }

}

close $blammofh;
print "Success!\n";
