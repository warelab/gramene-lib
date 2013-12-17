#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;
use Net::Ping;

use_ok('Grm::Config');
use_ok('Grm::DB');
use_ok('Grm::Search');

my $conf;
ok( $conf = Grm::Config->new, 'Got Grm::Config' );
my @modules = $conf->get('modules');

my $count = scalar @modules;

ok( $count, "Got $count modules" );

my %reachable;
my $ping = Net::Ping->new( 'tcp', 2 );

for my $module ( @modules ) {
    ok( my $db = Grm::DB->new( $module ), "$module config OK" );

    my $host = $db->host;

    if ( !defined $reachable{ $host } ) {
        $reachable{ $host } = $ping->ping( $host );
    }

    SKIP: {
        skip "Can't reach host '$host'", 1 unless $reachable{ $host };
 
        my $dbh;
        eval { $dbh = $db->dbh };
        isa_ok( $dbh, 'DBI::db', "Connection to " . $db->real_name );
    }
}

done_testing();
