#!/usr/bin/env perl
use strict;

use DBI;
use Getopt::Long;

my ( $dbname, $dbuser, $dbpass, $dbhost, $dbport, $attribute );

GetOptions(
	'dbhost=s' => \$dbhost,
	'dbport=s' => \$dbport,
	'dbuser=s' => \$dbuser,
	'dbpass=s' => \$dbpass,
	'dbname=s' => \$dbname,
	'attribute=s' => \$attribute,
	) or die;
# connect to db

my $dba = DBI->connect( "DBI:mysql:database=$dbname;host=$dbhost;port=$dbport", $dbuser, $dbpass) or die "failed to connect to database: " . DBI->errstr;

# get the working-set gene ids
my $sth = $dba->prepare("select g.gene_id, g.stable_id from gene g, gene_attrib ga, attrib_type aty where g.gene_id = ga.gene_id and aty.code='$attribute' and aty.attrib_type_id = ga.attrib_type_id");
my $rv = $sth->execute or die $sth->errstr;
my %gene_stable_id;
while ( my ($gene_id, $stable_id) = $sth->fetchrow_array) {
	$gene_stable_id{$gene_id} = $stable_id;
}

my @gene_ids = keys %gene_stable_id;
fix_transcript_ids();
fix_exon_ids();
fix_translation_ids();

exit;

sub fix_transcript_ids() {
	# get all the associated transcripts and their names
	$sth = $dba->prepare("select transcript_id, gene_id, stable_id, version from transcript where gene_id IN (".join(',',@gene_ids).")");
	$rv = $sth->execute or die $sth->errstr;
	my %transcript_stable_id;
	while (my ($transcript_id, $gene_id, $stable_id, $version) = $sth->fetchrow_array) {
		$transcript_stable_id{$gene_id}{$transcript_id} = [$stable_id, $version];
	}
	# compare each stable_id to the gene_stable_id
	for my $gene_id (keys %transcript_stable_id) {
		defined $gene_stable_id{$gene_id} or die "missing gene_stable_id for $gene_id\n";
		# setup a regex to match against
		my $gsid = $gene_stable_id{$gene_id};
		my $re;
		if ($gsid =~ m/GRMZM/) {
			$re = "^${gsid}_T0*(\\d+)";
		} elsif ($gsid =~ m/[A-Z][A-Z]\d+\.\d_FG\d+/) {
			$gsid =~ s/_FG/_FGT/;
			$re = "^$gsid";
		} else {
			die "unexpected format for gene stable id '$gsid'\n";
		}
		my (%seen, @rename);
		for my $transcript_id (keys %{$transcript_stable_id{$gene_id}}) {
			my ($tsid, $version) = @{$transcript_stable_id{$gene_id}{$transcript_id}};
			if ($tsid !~ m/$re/) {
				print STDERR "renaming $tsid doesn't match $re\n";
				push @rename, $transcript_id;
			}
			else {
				$seen{$1} = $transcript_id;
			}
		}
		if (@rename) {
			if ($gsid =~ m/GRMZM/) {
				my $i=1;
				for my $transcript_id (@rename) {
					while ($seen{$i}) {
						$i++;
					}
					my $tsid = $gsid . "_T";
					$tsid .= ($i>9)? $i : "0$i";
					print "update transcript set stable_id=\"$tsid\" where transcript_id = $transcript_id;\n";
					$i++;
				}
			}
			else {
				print STDERR "rename '$gsid' to a GRMZM6G name - transcript\n";
			}
		}
	}
}

sub fix_translation_ids() {
	# get all the associated translations and their names
	$sth = $dba->prepare("select tl.translation_id, t.gene_id, tl.stable_id, tl.version from translation tl, transcript t where tl.transcript_id = t.transcript_id and t.gene_id IN (".join(',',@gene_ids).")");
	$rv = $sth->execute or die $sth->errstr;
	my %translation_stable_id;
	while (my ($translation_id, $gene_id, $stable_id, $version) = $sth->fetchrow_array) {
		$translation_stable_id{$gene_id}{$translation_id} = [$stable_id, $version];
	}
	# compare each stable_id to the gene_stable_id
	for my $gene_id (keys %translation_stable_id) {
		defined $gene_stable_id{$gene_id} or die "missing gene_stable_id for $gene_id\n";
		# setup a regex to match against
		my $gsid = $gene_stable_id{$gene_id};
		my $re;
		if ($gsid =~ m/GRMZM/) {
			$re = "^${gsid}_P0*(\\d+)";
		} elsif ($gsid =~ m/[A-Z][A-Z]\d+\.\d_FG\d+/) {
			$gsid =~ s/_FG/_FGP/;
			$re = "^$gsid";
		} else {
			die "unexpected format for gene stable id '$gsid'\n";
		}
		my (%seen, @rename);
		for my $translation_id (keys %{$translation_stable_id{$gene_id}}) {
			my ($tsid, $version) = @{$translation_stable_id{$gene_id}{$translation_id}};
			if ($tsid !~ m/$re/) {
				print STDERR "renaming $tsid doesn't match $re\n";
				push @rename, $translation_id;
			}
			else {
				$seen{$1} = $translation_id;
			}
		}
		if (@rename) {
			if ($gsid =~ m/GRMZM/) {
				my $i=1;
				for my $translation_id (@rename) {
					while ($seen{$i}) {
						$i++;
					}
					my $tsid = $gsid . "_P";
					$tsid .= ($i>9)? $i : "0$i";
					print "update translation set stable_id=\"$tsid\" where translation_id = $translation_id;\n";
					$i++;
				}
			}
			else {
				print STDERR "rename '$gsid' to a GRMZM6G name - translation\n";
			}
		}
	}
}

sub fix_exon_ids() {
	# get all the associated exons and their names
	$sth = $dba->prepare("select e.exon_id, t.gene_id, e.stable_id, e.version from exon e, exon_transcript et, transcript t where e.exon_id = et.exon_id and et.transcript_id = t.transcript_id and t.gene_id IN (".join(',',@gene_ids).")");
	$rv = $sth->execute or die $sth->errstr;
	my %exon_stable_id;
	while (my ($exon_id, $gene_id, $stable_id, $version) = $sth->fetchrow_array) {
		$exon_stable_id{$gene_id}{$exon_id} = [$stable_id, $version];
	}
	# compare each stable_id to the gene_stable_id
	for my $gene_id (keys %exon_stable_id) {
		defined $gene_stable_id{$gene_id} or die "missing gene_stable_id for $gene_id\n";
		# setup a regex to match against
		my $gsid = $gene_stable_id{$gene_id};
		my $re;
		if ($gsid =~ m/GRMZM/) {
			$re = "^${gsid}_E0*(\\d+)";
		} elsif ($gsid =~ m/[A-Z][A-Z]\d+\.\d_FG\d+/) {
			$re = "^$gsid";
		} else {
			die "unexpected format for gene stable id '$gsid'\n";
		}
		my (%seen, @rename);
		for my $exon_id (keys %{$exon_stable_id{$gene_id}}) {
			my ($tsid, $version) = @{$exon_stable_id{$gene_id}{$exon_id}};
			if ($tsid !~ m/$re/) {
				print STDERR "renaming $tsid doesn't match $re\n";
				push @rename, $exon_id;
			}
			else {
				$seen{$1} = $exon_id;
			}
		}
		if (@rename) {
			if ($gsid =~ m/GRMZM/) {
				my $i=1;
				for my $exon_id (@rename) {
					while ($seen{$i}) {
						$i++;
					}
					my $tsid = $gsid . "_E";
					$tsid .= ($i>9)? $i : "0$i";
					print "update exon set stable_id=\"$tsid\" where exon_id = $exon_id;\n";
					$i++;
				}
			}
			else {
				print STDERR "rename '$gsid' to a GRMZM6G name - exon\n";
			}
		}
	}
}
