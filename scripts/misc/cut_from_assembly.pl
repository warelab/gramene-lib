#!/usr/bin/perl -w
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Slice;
use Getopt::Long;
use DBI qw(:sql_types);

my ( $dbname, $dbuser, $dbpass, $dbhost, $dbport, $tocut, $run );

GetOptions(
    'dbhost=s' => \$dbhost,
    'dbport=s' => \$dbport,
    'dbuser=s' => \$dbuser,
    'dbpass=s' => \$dbpass,
    'dbname=s' => \$dbname,
    'cut=s'    => \$tocut,
    'run'      => \$run
) or die "GetOptions() failure: $!\n";

my $dba = Bio::EnsEMBL::DBSQL::DBAdaptor->new(
    -user   => $dbuser,
    -pass   => $dbpass,
    -dbname => $dbname,
    -host   => $dbhost,
    -port   => $dbport,
    -driver => 'mysql'
);

my $sthash = prepare_SQL_statements();

open( my $fh, "<", $tocut ) or die "failed to open $tocut for reading: $!\n";
while (<$fh>) {
    chomp;

    # lookup seq_region_id to cut from the db
    my $seq_region_id = get_seq_region_id($_);
    $seq_region_id or die "failed to find seq_region_id of '$_'\n";

    # remove seq_region_id from assembly table
    my ( $asm_seq_region_id, $from, $to ) = assembly_location($seq_region_id);
    $asm_seq_region_id
      or die "failed to find asm_seq_region_id of $seq_region_id\n";

    # determine the appropriate gap size (keep the larger gap)
    my $before_gap = $from - previous_cmp( $asm_seq_region_id, $from ) - 1;
    my $after_gap = next_cmp( $asm_seq_region_id, $to ) - $to - 1;
    my $cut_n = $before_gap > $after_gap ? $after_gap : $before_gap;
    $cut_n += $to - $from + 1;
    print STDERR
"##$_ $seq_region_id $asm_seq_region_id from $from to $to before $before_gap after $after_gap cut $cut_n\n";

    ## shift the rest of the assembly table by the appropriate amount
    my $sql = "delete from assembly where cmp_seq_region_id = $seq_region_id;";
    print STDERR "$sql\n";
    my $rv = $sthash->{del_region}->execute($seq_region_id);

    $sql =
"update assembly set asm_start=asm_start-$cut_n, asm_end=asm_end-$cut_n where asm_seq_region_id=$asm_seq_region_id and asm_start >= $from;";
    print STDERR "$sql\n";
    $rv =
      $sthash->{update}{assembly}
      ->execute( $cut_n, $cut_n, $asm_seq_region_id, $from );
    ## shift the annotations too
    for my $table (qw(repeat_feature gene transcript exon)) {
        $sql =
"update $table set seq_region_start=seq_region_start-$cut_n, seq_region_end=seq_region_end-$cut_n where seq_region_id=$asm_seq_region_id and seq_region_start >= $from;";
        print STDERR "$sql\n";
        $rv =
          $sthash->{update}{$table}
          ->execute( $cut_n, $cut_n, asm_seq_region_id, $from );
    }
}
close $fh;
exit;

sub prepare_SQL_statements {
    my %sth;
    $sth{seq_region} =
      $dba->prepare("select seq_region_id from seq_region where name = ?");
    $sth{asm_seq_region} = $dba->prepare(
"select asm_seq_region_id,asm_start,asm_end from assembly where cmp_seq_region_id = ?"
    );
    $sth{prev_end} = $dba->prepare(
"select asm_end from assembly where asm_seq_region_id = ? and asm_end < ? order by asm_start DESC limit 1"
    );
    $sth{next_start} = $dba->prepare(
"select asm_start from assembly where asm_seq_region_id = ? and asm_start > ? order by asm_start limit 1"
    );
    $sth{del_region} =
      $dba->prepare("delete from assembly where cmp_seq_region_id = ?");
    $sth{update}{assembly} = $dba->prepare(
"update assembly set asm_start=asm_start-?, asm_end=asm_end-? where asm_seq_region_id=? and asm_start >= ?"
    );
    for my $table (qw(repeat_feature gene transcript exon)) {
        $sth{update}{$table} = $dba->prepare(
"update $table set seq_region_start=seq_region_start-?, seq_region_end=seq_region_end-? where seq_region_id=? and seq_region_start >= ?"
        );
    }
    return \%sth;
}

sub get_seq_region_id {
    my $name    = shift;
    my $rv      = $sthash->{seq_region}->execute($name);
    my $ary_ref = $sthash->{seq_region}->fetch;
    return $$ary_ref[0];
}

sub assembly_location {
    my $seq_region_id = shift;
    $sthash->{asm_seq_region}->bind_param( 1, $seq_region_id, SQL_INTEGER );
    my $rv = $sthash->{asm_seq_region}->execute();
    return $sthash->{asm_seq_region}->fetchrow_array;
}

sub next_cmp {
    my ( $asm_seq_region_id, $pos ) = @_;
    $sthash->{next_start}->bind_param( 1, $asm_seq_region_id, SQL_INTEGER );
    $sthash->{next_start}->bind_param( 2, $pos, SQL_INTEGER );
    my $rv      = $sthash->{next_start}->execute();
    my $ary_ref = $sthash->{next_start}->fetch;
    return $$ary_ref[0];
}

sub previous_cmp {
    my ( $asm_seq_region_id, $pos ) = @_;
    $sthash->{prev_end}->bind_param( 1, $asm_seq_region_id, SQL_INTEGER );
    $sthash->{prev_end}->bind_param( 2, $pos, SQL_INTEGER );
    my $rv      = $sthash->{prev_end}->execute();
    my $ary_ref = $sthash->{prev_end}->fetch;
    return $$ary_ref[0];
}
