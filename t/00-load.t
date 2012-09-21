#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Gramene' ) || print "Bail out!\n";
}

diag( "Testing Gramene $Gramene::VERSION, Perl $], $^X" );
