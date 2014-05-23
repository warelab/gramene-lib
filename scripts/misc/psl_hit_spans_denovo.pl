#!/usr/bin/perl -w
use strict;
my @PSL = (
    'match',       'mismatch',    'rep_match',   'Ns',
    'q_gap_count', 'q_gap_bases', 't_gap_count', 't_gap_bases',
    'strand',      'q_name',      'q_size',      'q_start',
    'q_end',       't_name',      't_size',      't_start',
    't_end',       'block_count', 'blockSizes',  'qStarts',
    'tStarts'
);

my $agp = shift @ARGV;
my $psl = shift @ARGV;
$psl and $agp
  or die "usage:\n$0 maize.agp improved_flcDNAs.psl\n\n";

my %AGP_map;
open (my $fh, "<", $agp) or die "failed to open $agp for reading: \n";
while (<$fh>) {
	chomp;
	my ($chr, $from, $to, $i, $DN, $clone, @etc) = split /\t/, $_;
	$DN or next;
	$chr = "chr$chr" if $chr =~ m/^\d+$/;
	if ($DN eq 'D') {
		push @{$AGP_map{$chr}}, [$from,$to,$clone];
	}
}
close $fh;

open( $fh, "<", $psl )
  or die "failed to open $psl for reading : $!\n";
while (my $hits = read_next($fh)) {
	my ($chr,$from,$to) = ($hits->[0]{t_name},$hits->[0]{t_start},$hits->[0]{t_end});
	for (my $i=1;$i<@$hits;$i++) {
		if ($hits->[$i]{t_start} < $from) {
			$from = $hits->[$i]{t_start};
		}
		if ($hits->[$i]{t_end} > $to) {
			$to = $hits->[$i]{t_end};
		}
	}
	next if (coverage($hits)/$hits->[0]{q_size} < 0.5);
	my @clones = agp_overlaps($AGP_map{$chr},$from,$to);
	for my $clone (@clones) {
		if ($clone =~ m/^k\d\d_\d+$/) {
			print join("\t", $hits->[0]{q_name}, $chr, $from, $to, $hits->[0]{strand}, $clone),"\n";
		}
	}
}
close $fh;

exit;

sub read_next {
    my $fh = shift;
    my @hits;
    my $pos = tell $fh;
    my $seq;
    while (<$fh>) {
        /^[0-9]/ or next;
        my %hit;
        chomp;
        my @c = split /\t/, $_;
        for ( my $i = 0 ; $i < @c ; $i++ ) {
            $hit{ $PSL[$i] } = $c[$i];
        }
        if ( $seq and $hit{q_name} ne $seq ) {
            seek( $fh, $pos, 0 );
            return \@hits;
        }
        $seq = $hit{q_name};
        push @hits, \%hit;
        $pos = tell $fh;
    }
    return @hits ? \@hits : undef;
}


sub agp_overlaps {
	my ($intervals,$min,$max) = @_;
	my @clones;
	for my $interval (@$intervals) {
		next if ($interval->[1] < $min);
		last if ($interval->[0] > $max);
		push @clones, $interval->[2];
	}
	return @clones;
}

sub by_qstart {
    $a->{q_start} <=> $b->{q_start}
      or $a->{t_name} cmp $b->{t_name}
      or $a->{t_start} <=> $b->{t_start};
}

sub coverage {
    my ( $scaffold ) = @_;
    @$scaffold or return 0;
    my @hits     = sort by_qstart @$scaffold;
    my $hit      = shift @hits;
    my $max      = $$hit{q_end};
    my $coverage = $$hit{q_end} - $$hit{q_start};
    for $hit (@hits) {
        if ( $$hit{q_end} > $max ) {
            if ( $$hit{q_start} > $max ) {
                $coverage += $$hit{q_end} - $$hit{q_start};
            }
            else {
                $coverage += $$hit{q_end} - $max;
            }
            $max = $$hit{q_end};
        }
    }
    return $coverage;
}