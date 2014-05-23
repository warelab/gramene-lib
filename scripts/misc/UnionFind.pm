package UnionFind;

use strict;

sub new {
    my $name  = shift;
    my $class = ref($name) || $name;
    my $this  = {};
    bless $this, $class;
    $this->{parent}    = {};
    $this->{rank}      = {};
    $this->{is_root}   = {};
    $this->{neighbors} = {};
    return $this;
}

### disjoint set methods: union by rank with path compression and connected components
sub MakeSet {
    my $this      = shift;
    my $x         = shift;
    my $agp_range = shift;    # [chr, from, to]
    $this->{parent}{$x}    = $x;
    $this->{rank}{$x}      = 0;
    $this->{is_root}{$x}   = 1;
    $this->{neighbors}{$x} = [$x];
    $this->{agp_range}{$x} = $agp_range;
}

sub AGP_range {
    my $this = shift;
    my $x    = shift;
    my $root = $this->Find($x);
    my ( $chr, $from, $to, $strand, $fixed ) = @{ $this->{agp_range}{$root} };
    $from++;
    return $chr ? "$chr:$from-$to:$strand:$fixed" : '-';
}

my $max_gap = 10000;

sub Compatible {
    my ( $this, $x, $y ) = @_;
    my $xRoot = $this->Find($x);
    my $yRoot = $this->Find($y);
    if ( @{ $this->{agp_range}{$xRoot} } and @{ $this->{agp_range}{$yRoot} } ) {

        # need to check
        my ( $x_chr, $x_from, $x_to, $x_ori, $x_fix ) =
          @{ $this->{agp_range}{$xRoot} };
        my ( $y_chr, $y_from, $y_to, $y_ori, $y_fix ) =
          @{ $this->{agp_range}{$yRoot} };
        $x_chr eq $y_chr or return 0;
        my $check_ori = $x_fix || $y_fix;
        if ( $check_ori and $x_ori and $y_ori and $x_ori != $y_ori ) {
            return 0;
        }
        if ( $x_to < $y_from ) {
            ( $y_from - $x_to < $max_gap ) and return 1;
        }
        elsif ( $y_to < $x_from ) {
            ( $x_from - $y_to < $max_gap ) and return 1;
        }
        else {
            return 1;
        }
        return 0;
    }
    else {
        return 1;
    }
}

sub MergeAGP {
    my ( $this, $x, $y ) = @_;
    my @merged = ();
    if ( @{ $this->{agp_range}{$x} } ) {    # x is anchored
        @merged = @{ $this->{agp_range}{$x} };
        if ( @{ $this->{agp_range}{$y} } ) {    # y is also anchored
            if ( $this->{agp_range}{$y}[1] < $merged[1] ) {
                $merged[1] = $this->{agp_range}{$y}[1];
            }
            if ( $this->{agp_range}{$y}[2] > $merged[2] ) {
                $merged[2] = $this->{agp_range}{$y}[2];
            }
            $merged[3] ||= $this->{agp_range}{$y}[3];    # oriented
            $merged[4] ||= $this->{agp_range}{$y}[4];    # fixed orientation
        }
    }
    elsif ( @{ $this->{agp_range}{$y} } ) {              # only y is anchored
        @merged = @{ $this->{agp_range}{$y} };
    }
    return \@merged;
}

sub Union {
    my ( $this, $x, $y ) = @_;
    $this->Compatible( $x, $y ) or return 0;
    my $xRoot = $this->Find($x);
    my $yRoot = $this->Find($y);
    if ( $this->{rank}{$xRoot} > $this->{rank}{$yRoot} ) {
        $this->{parent}{$yRoot}    = $xRoot;
        $this->{is_root}{$xRoot}   = 1;
        $this->{agp_range}{$xRoot} = $this->MergeAGP( $xRoot, $yRoot );
        push @{ $this->{neighbors}{$xRoot} }, @{ $this->{neighbors}{$yRoot} };
        delete $this->{neighbors}{$yRoot};
        delete $this->{agp_range}{$yRoot};
        delete $this->{is_root}{$yRoot};
    }
    elsif ( $this->{rank}{$xRoot} < $this->{rank}{$yRoot} ) {
        $this->{parent}{$xRoot}    = $yRoot;
        $this->{is_root}{$yRoot}   = 1;
        $this->{agp_range}{$yRoot} = $this->MergeAGP( $xRoot, $yRoot );
        push @{ $this->{neighbors}{$yRoot} }, @{ $this->{neighbors}{$xRoot} };
        delete $this->{neighbors}{$xRoot};
        delete $this->{agp_range}{$xRoot};
        delete $this->{is_root}{$xRoot};
    }
    elsif ( $xRoot != $yRoot ) {
        $this->{parent}{$yRoot} = $xRoot;
        $this->{rank}{$xRoot}++;
        $this->{is_root}{$xRoot} = 1;
        $this->{agp_range}{$xRoot} = $this->MergeAGP( $xRoot, $yRoot );
        push @{ $this->{neighbors}{$xRoot} }, @{ $this->{neighbors}{$yRoot} };
        delete $this->{neighbors}{$yRoot};
        delete $this->{agp_range}{$yRoot};
        delete $this->{is_root}{$yRoot};
    }
    return 1;
}

sub Find {
    my $this = shift;
    my $x    = shift;
    if ( $this->{parent}{$x} == $x ) {
        return $x;
    }
    else {
        $this->{parent}{$x} = $this->Find( $this->{parent}{$x} );
        return $this->{parent}{$x};
    }
}

sub Neighbors {
    my ( $this, $x ) = @_;
    my $root = $this->Find($x);
    return $this->{neighbors}{$root};
}

sub Check {
    my ( $this, $x ) = @_;
    my $root = $this->Find($x);
    return $this->{agp_range}{$root}[4];
}

sub Roots {
    my $this = shift;
    return keys %{ $this->{is_root} };
}

1;
