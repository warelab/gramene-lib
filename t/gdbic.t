#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;

use_ok('Grm::Config');
use_ok('Grm::Utils');
use_ok('Grm::DB');

ok( my $config = Grm::Config->new, 'Made the config object' );

ok( my @modules = $config->get('modules'), 'Got modules' );

my %seen;
for my $m ( @modules ) {
#    my $class = module_name_to_gdbic_class( $m );
#    next if $seen{ $class }++;
#    require_ok $class;
    ok( my $schema = Grm::DB->new( $m )->gcdbi );
    isa_ok( $schema, 'Grm::CDBI' );
}

done_testing();
