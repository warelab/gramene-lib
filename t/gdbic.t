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

for my $m ( @modules ) {
    ok( my $schema = Grm::DB->new( $m )->dbic, $m );
    isa_ok( $schema, 'DBIx::Class::Schema' );
    last;
}

ok( my $schema = Grm::DB->new( $modules[0] )->schema, "'schema' alias" );
isa_ok( $schema, 'DBIx::Class::Schema' );

done_testing();
