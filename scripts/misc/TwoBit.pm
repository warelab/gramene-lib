package TwoBit;

use strict;

sub new {
    my $name  = shift;
    my $class = ref($name) || $name;
    my $this  = {};
    bless $this, $class;
    return $this;
}

sub load {
    my ( $this, $file ) = @_;
    $this->{file} = $file;
    my $cmd = "twoBitInfo $file /dev/fd/1";
    open( INFO, "$cmd |" ) or die "failed to run $cmd: $!\n";
    while (<INFO>) {
        chomp;
        my ( $seq, $len ) = split /\t/, $_;
        $this->{length}{$seq} = $len;
		print STDERR "$seq\t$len\n";
    }
    close INFO;
}

sub fetch {
    my ( $this, $id, $flip ) = @_;
    my $cmd = "twoBitToFa -seq=$id $this->{file} /dev/fd/1";
    open( FA, "$cmd |" ) or die "failed to run $cmd: $!\n";
    my $seq = '';
    while (<FA>) {
        next if /^>/;
        chomp;
        $seq .= $_;
    }
    close FA;
    return $flip ? flip($seq) : $seq;
}

sub flip {
    my $seq = shift;
    my $qes = reverse $seq;
    $qes =~ tr/ACGTacgt/TGCAtgca/;
    return $qes;
}

sub fetch_substr {
    my ( $this, $id, $start, $end, $flip ) = @_;
    my $cmd =
      "twoBitToFa -seq=$id -start=$start -end=$end $this->{file} /dev/fd/1";
    open( FA, "$cmd |" ) or die "failed to run $cmd: $!\n";
    my $seq = '';
    while (<FA>) {
        next if /^>/;
        chomp;
        $seq .= $_;
    }
    close FA;
    return $flip ? flip($seq) : $seq;
}

1;
