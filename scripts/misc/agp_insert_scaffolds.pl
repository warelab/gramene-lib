#!/usr/bin/perl -w
use strict;

my $agp_file = shift @ARGV;

my $agp_fh;
if ( $agp_file =~ m/\.gz$/ ) {
    open( $agp_fh, "gzip -cd $agp_file |" )
      or die "failed to gzip -cd $agp_file : $!\n";
}
else {
    open( $agp_fh, "<", $agp_file )
      or die "failed to open $agp_file for reading : $!\n";
}

my %agp;
while (<$agp_fh>) {
    chomp;
    my @agp_row = split /\t/, $_;
    my $chr = shift @agp_row;
    if ( not exists $agp{$chr} ) {
        $agp{$chr} = [];
    }
    push @{ $agp{$chr} }, \@agp_row;
}
close $agp_fh;

print STDERR "finished reading agp\n";

my %scaffolds;
while (<>) {
    next if /^#/;
    chomp;
    my @row = split /\t/, $_;
    my $id = shift @row;
    if ( not exists $scaffolds{$id} ) {
        $scaffolds{$id} = [];
    }
    push @{ $scaffolds{$id} }, \@row;
}

print STDERR "finished reading new scaffolds\n";

my %placements;
my $n_unknown = @{ $agp{UNKNOWN} };
while ( my ( $id, $scaffold ) = each %scaffolds ) {

    #    print "$id\n";
    #    for my $hit (@$scaffold) {
    #        print join( "\t", @$hit ), "\n";
    #    }
    my ( $chr, $from, $to ) = $scaffold->[0][8] =~ m/chr(\d+):(\d+)-(\d+)/;
    if ($chr) {
        defined $agp{$chr} or die "not defined agp{$chr}\n";
        my $pos = bsearch( int( ( $from + $to ) / 2 ),
            $agp{$chr}, 0, @{ $agp{$chr} } - 1 );

        #        print "FOUND: $chr $pos\n";
        push @{ $placements{$chr}{$pos} }, $id;
    }
    else {
        push @{ $placements{UNKNOWN}{$n_unknown} }, $id;
    }
}
push @{ $agp{UNKNOWN} },
  [
    $agp{UNKNOWN}[-1][1] + 1,
    $agp{UNKNOWN}[-1][1] + 100,
    $n_unknown + 1,
    'N', 100, 'fragment', 'no', 'NA'
  ];

print STDERR "finished locating new scaffolds\n";

for my $chr ( keys %agp ) {
    if ( $placements{$chr} ) {
        my $curr_pos = 0;
        my @places = sort { $a <=> $b } keys %{ $placements{$chr} };
        while (@places) {
            my $next_pos = shift @places;
            for ( my $i = $curr_pos ; $i < $next_pos ; $i++ ) {
                print join( "\t", $chr, @{ $agp{$chr}[$i] } ), "\n";
            }
            $curr_pos = $next_pos + 1;
            if ( $agp{$chr}[$next_pos][4] eq 'D' ) {
                print STDERR join( "\t", $chr, @{ $agp{$chr}[$next_pos] } ),
                  "\n";
                die "scaffold in a non-gap\n";
            }
            my @gs;
            for my $id ( @{ $placements{$chr}{$next_pos} } ) {
                if (@gs) {
                    push @gs,
                      [ "pre$id", 1, 100, 1, 'N', 100, "fragment", "no" ];
                }
                for my $row ( @{ $scaffolds{$id} } ) {
                    unshift @$row, $id;
                    push @gs, $row;
                }
            }

            # if the first pos is not a chr print the gap
            if ( $gs[0][5] !~ m/^chr/ ) {
                print join( "\t", $chr, @{ $agp{$chr}[$next_pos] } ), "\n";
            }

            # iterate over the @gs (gene scaffold)
            for ( my $i = 0 ; $i < @gs ; $i++ ) {
                if ( $gs[$i][5] =~ m/^chr/ ) {
                    if ( $i > 0 and $i < @gs - 1 ) {
                        print STDERR
                          "bridge scaffold in the middle of the gap\n";
                        for my $scaf (@gs) {
                            print STDERR join( "\t", "---", @$scaf ), "\n";
                        }
                    }
                    next;
                }
                print join( "\t", @{ $gs[$i] } ), "\n";
            }

            # if the last pos is not a chr, print the gap
            if ( $gs[-1][5] !~ m/^chr/ and $next_pos < @{$agp{$chr}} - 1) {
                print join( "\t", $chr, @{ $agp{$chr}[$next_pos] } ), "\n";
            }
        }
        for ( my $i = $curr_pos ; $i < @{ $agp{$chr} } ; $i++ ) {
            print join( "\t", $chr, @{ $agp{$chr}[$i] } ), "\n";
        }
    }
    else {
        for my $agp_row ( @{ $agp{$chr} } ) {
            print join( "\t", $chr, @$agp_row ), "\n";
        }
    }
}

exit;

sub bsearch {
    my ( $n, $intervals, $a, $b ) = @_;
    if ( $a == $b ) {
        return $a;
    }
    my $mid = int( ( $a + $b ) / 2 );
    if ( $n < $intervals->[$mid][0] ) {
        return bsearch( $n, $intervals, $a, $mid );
    }
    elsif ( $intervals->[$mid][1] < $n ) {
        return bsearch( $n, $intervals, $mid + 1, $b );
    }
    else {
        return $mid;
    }
}
