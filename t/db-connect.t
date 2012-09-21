#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More 'no_plan';

use_ok('Grm::Config');
use_ok('Grm::DB');

my $conf;
ok( $conf = Grm::Config->new, 'Got Grm::Config' );
my @modules = $conf->get('modules');

my $count = scalar @modules;

ok( $count, "Got $count modules" );

plan tests => $count + 3;

for my $module ( @modules ) {
   ok( Grm::DB->new( $module ), "$module OK" );
}
