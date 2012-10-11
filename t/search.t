#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More;# tests => 16;

$ENV{'GrmConfPath'} = catfile( $Bin, 'data', 'gramene.yaml.test' );

use_ok('Grm::Search');

{
    ok( my $search = Grm::Search->new( base_dir => $Bin ), 'got a search obj' );

    is( $search->page_size, 10, 'default page size is 10' );

    is( $search->index_path, 
        catdir( $Bin, 'data/search-index' ), 'BUILD uses base_dir' 
    );

    ok( my @res = $search->search( query => 'waxy' ), 
        'execute search for "waxy"' 
    );

    is( scalar @res, 4, 'found 4 hits' );
}

{
    ok( my $search = Grm::Search->new( base_dir => $Bin, page_size => 25 ), 
        'new with page_size'
    );

    is( $search->page_size, 25, 'BUILD uses page_size' );
}

done_testing();
