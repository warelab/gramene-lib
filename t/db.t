#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More 'no_plan'; #tests => 21;

$ENV{'GrameneConfPath'} = catfile( $Bin, 'data', 'gramene.conf.test' );

use_ok('Grm::DB');

{
    throws_ok( sub { Grm::DB->new }, qr/Attribute \(db_name\) is required/, 
        'Dies without arguments' );

    throws_ok( sub { Grm::DB->new( db_name => 'bad_db' ) }, 
        qr/Unknown database/, 'Dies on bad db name'
    );

    my $db = new_ok('Grm::DB', [ db_name => 'foo' ] ) or die;

    is( $db->dbd, 'mysql', '"mysql" is default DBD' );

    my $opts = $db->db_options; 
    isa_ok( $opts, 'HASH', 'db_options' );

    is( $opts->{'RaiseError'}, 1, '"RaiseError" is a default option' );

}

#
# Alternate "new" args
#
{
    my $db1 = Grm::DB->new( db_name => 'foo' );
    is( $db1->db_name, 'foo', '"db_name" works' );
    is( $db1->real_name, 'foo34', '"real_name" OK' );

    my $db2 = Grm::DB->new( db => 'bar' );
    is( $db2->db_name, 'bar', '"db" alias works' );

    my $db3 = Grm::DB->new( name => 'baz');
    is( $db3->db_name, 'baz', '"name" alias works' );

    my $db4 = Grm::DB->new('baz');
    is( $db4->db_name, 'baz', 'single-arg new works' );
}

{
    my $test_db  = catfile( $Bin, 'data', 'test.db' );
    my $dsn      = "dbi:SQLite:$test_db";
    my $db       = Grm::DB->new(
        db_name  => 'test',
        dsn      => $dsn,
        user     => '',
        password => '',
    );
    is( $db->dsn, $dsn, 'DSN is OK' );

    my $dbh = $db->dbh;
    isa_ok( $dbh, 'DBI::db', 'dbh' );

    my $data = $dbh->selectall_arrayref(
        'select test_id, value from test', { Columns => {} }
    );

    cmp_ok( @$data, '>', 0, 'Found some test data' );
    is( $data->[0]{'value'}, 'foo', 'Found "foo"' );
}
