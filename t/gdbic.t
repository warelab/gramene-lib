#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More tests => 1;

use_ok('Grm::Config');
use_ok('Grm::Utils');

ok( my $config = Grm::Config->new, 'Made the config object' );

ok( my @modules = $config->get('modules'), 'Got modules' );

for my $m ( @modules ) {
    my $class = module_name_to_gdbic_class( $m );
    require_ok $class;
}
