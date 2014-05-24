package MyIntSpan;

use strict;
use base qw( Set::IntSpan );

sub span_ord {
    my ( $set, $n ) = @_;
    if ( not defined $set->{saved_spans} ) {
        my @spans = $set->spans;
        $set->{saved_spans} = \@spans;
    }
    return binary_search_intervals( $n, $set->{saved_spans}, 0,
        scalar @{ $set->{saved_spans} } - 1 );
}

sub span_index {
    my ( $set, $i ) = @_;
    if ( not defined $set->{saved_spans} ) {
        my @spans = $set->spans;
        $set->{saved_spans} = \@spans;
    }
    return $set->{saved_spans}[$i];
}

sub check_interval {
    my ( $n, $from, $to ) = @_;
    if ( defined $from and $n < $from ) { return -1; }
    if ( defined $to   and $n > $to )   { return 1; }
    return 0;
}

sub binary_search_intervals {
    my ( $n, $intervals, $a, $b ) = @_;
    if ( $a == $b ) {
        my $check = check_interval( $n, @{ $intervals->[$a] } );
        return $check == 0 ? $a : undef;
    }
    my $mid = int( ( $a + $b ) / 2 );
    my $check = check_interval( $n, @{ $intervals->[$mid] } );
    if ( $check == 1 ) {
        return binary_search_intervals( $n, $intervals, $mid + 1, $b );
    }
    if ( $check == -1 ) {
        $a == $mid and return undef;
        return binary_search_intervals( $n, $intervals, $a, $mid - 1 );
    }
    return $mid;
}

1;
