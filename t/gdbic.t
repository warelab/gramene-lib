#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;

use_ok('Grm::Config');
use_ok('Grm::Utils');

ok( my $config = Grm::Config->new, 'Made the config object' );

ok( my @modules = $config->get('modules'), 'Got modules' );

my %seen;
for my $m ( @modules ) {
    my $class = module_name_to_gdbic_class( $m );
    next if $seen{ $class }++;
    require_ok $class;
}

done_testing();
