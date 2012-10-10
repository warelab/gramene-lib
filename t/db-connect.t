#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;

use_ok('Grm::Config');
use_ok('Grm::DB');

my $conf;
ok( $conf = Grm::Config->new, 'Got Grm::Config' );
my @modules = $conf->get('modules');

my $count = scalar @modules;

ok( $count, "Got $count modules" );

for my $module ( @modules ) {
   ok( my $db = Grm::DB->new( $module ), "$module OK" );
   ok( my $dbh = $db->dbh, 'Got a db handle' );
}

done_testing();
