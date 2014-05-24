package FastaIndex;

use strict;

sub new {
    my $name  = shift;
    my $class = ref($name) || $name;
    my $this  = {};
    bless $this, $class;
    return $this;
}

sub index {
    my ( $this, $dir ) = @_;
    my @files  = glob "$dir/*.fa";
    my $nfiles = @files;
    print STDERR "indexing $nfiles: @files\n";
    my ( $range_fh, $offsets_fh, $in_fh );
    open( $range_fh, ">", "$dir/index.range" )
      or die "failed to open $dir/index.range for writing: $!\n";
    for ( my $i = 1 ; $i <= $nfiles ; $i++ ) {
        print STDERR "indexing $i.fa\n";

        my @offsets;
        open( $in_fh, "<", "$dir/$i.fa" )
          or die "failed to open $dir/$i.fa for reading: $!\n";
        my ( $first, $last );
        my $pos = 0;
        while (<$in_fh>) {
            if ( my ($id) = /^>(\d+)/ ) {
                if ($pos) {
                    for ( my $j = $last + 1 ; $j < $id ; $j++ ) {
                        push @offsets, 0;
                    }
                }
                else {
                    $first = $id;
                }
                $pos = tell $in_fh;
                push @offsets, $pos;
                $last = $id;
            }
        }
        close $in_fh;
        my $n = @offsets;
        $n == $last - $first + 1 or die "error: n=$n first=$first last=$last\n";
        my $packed = pack "L$n", @offsets;
        open( $offsets_fh, ">", "$dir/$i.offsets" )
          or die "failed to open $dir/$i.offsets for writing: $!\n";
        print $offsets_fh $packed;
        close $offsets_fh;
        print $range_fh "$i\t$first\t$last\n";
    }
    close $range_fh;
}

sub load {
    my ( $this, $dir ) = @_;
    -e "$dir/index.range" or die "$dir/index.range not found\n";
    my $range_fh;
    open( $range_fh, "<", "$dir/index.range" )
      or die "failed to open $dir/index.range for reading : $!\n";
    while (<$range_fh>) {
        chomp;
        my ( $i, $first, $last ) = split /\t/, $_;
        push @{ $this->{intervals} }, [ $first, $last, $i ];
        my $n = $last - $first + 1;
        open( $this->{fa}[$i], "<", "$dir/$i.fa" )
          or die "failed to open $dir/$i.fa for reading : $!\n";
        my $OFFSETS;
        open( $OFFSETS, "<", "$dir/$i.offsets" )
          or die "failed to open $dir/$i.offsets for reading : $!\n";
        my $p;
        read $OFFSETS, $p, $n * 4;
        close $OFFSETS;
        my @o = unpack "L$n", $p;
        $this->{idx}[$i] = \@o;
    }
    close $range_fh;
}

sub fetch {
    my ( $this, $id, $flip ) = @_;
    my $location = $this->locate_seq( $id, 0, @{ $this->{intervals} } - 1 );
    $location or return '';
    my ( $first, $last, $i ) = @$location;
    my $offset = $this->{idx}[$i][ $id - $first ];
    $offset or return '';
    my $idx_size = scalar @{ $this->{idx}[$i] };
    my $idx      = $id - $first;
    seek( $this->{fa}[$i], $offset, 0 );
    my $fh  = $this->{fa}[$i];
    my $seq = <$fh>;
    chomp $seq;

    if ($flip) {
        $seq =~ tr/ACGT/TGCA/;
        $seq = join( '', reverse split //, $seq );
    }
    return $seq;
}

sub locate_seq {
    my ( $this, $c, $a, $b ) = @_;
    if ( $c > $this->{intervals}[$b][1] ) {
        return undef;
    }

    # check if $c is in the middle interval int(($a+$b)/2)
    my $mid = int( ( $a + $b ) / 2 );
    if ( $c < $this->{intervals}[$mid][0] ) {
        return $this->locate_seq( $c, $a, $mid - 1 );
    }
    if ( $c > $this->{intervals}[$mid][1] ) {
        return $this->locate_seq( $c, $mid + 1, $b );
    }
    return $this->{intervals}[$mid];
}

1;
