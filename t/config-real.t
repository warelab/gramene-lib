#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More tests => 6;

use_ok('Grm::Config');

ok( my $config = Grm::Config->new, 'Made the config object' );

ok( my $conf_hash = $config->config, 'Got the config data' );

isa_ok( $conf_hash, 'HASH', 'config is a HASH' );

my %dbs = map  { $_, 1 } keys %{ $conf_hash->{'database'} };
my @bad = grep { !defined $dbs{ $_ } } @{ $config->get('modules') };

ok( my $ontology = $config->get('ontology'), 'Got ontology (separate file)' );

is( scalar @bad, 0, 'No bad dbs' );
