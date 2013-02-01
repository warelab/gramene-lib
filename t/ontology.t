#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;# tests => 16;

#$ENV{'GrmConfPath'} = catfile( $Bin, 'data', 'gramene.yaml.test' );

use_ok('Grm::Ontology');

ok( my $odb = Grm::Ontology->new, 'New ontology query' );

isa_ok( $odb, 'Grm::Ontology' );

is( $odb->module_name, 'ontology', 'module name is "ontology"' );

ok( my @types = $odb->types, 'got prefixes' );

is( scalar @types, 7, 'found 7 types' );

ok( my $db = $odb->db('eo'), 'got db obj' );

isa_ok( $db, 'Grm::DB' );

ok( my $conf = $odb->config, 'got config obj' );

isa_ok( $conf, 'Grm::Config' );

ok( my @results = $odb->search('*waxy*'), 'search for "waxy"' );

is( scalar @results, 3, 'found 3 results' );

done_testing();
