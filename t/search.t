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

    isa_ok( $search->schema, 'Lucy::Plan::Schema', 'schema OK' );

#    isa_ok( 
#        $search->indexer('diversity_rice'), 
#        'Lucy::Index::Indexer', 
#        'indexer OK' 
#    );

    ok( my @res = $search->search( query => 'waxy' ), 
        'execute search for "waxy"' 
    );

    is( scalar @res, 1, 'found 4 hits' );

    ok( my @res2 = $search->search( query => 'waxy' ), 'single-arg search' );

    is( scalar @res, 1, 'still found 4 hits' );

    ok( 
        my %index_only = $search->tables_to_index('ontology'), 
        'table_to_index returns'
    );

    my %should_be = (
        'term' => {
            'other_tables' => [
                {
                    'fields'     => [ 'definition' ],
                    'table_name' => 'term_definition'
                },
                {
                    'fields'     => [ 'term_type' ],
                    'table_name' => 'term_type'
                },
                {
                    'fields'     => [ 'synonym_name', 'synonym_acc' ],
                    'table_name' => 'term_synonym'
                }
            ],
            'fields' => [ 'term_name', 'term_accession' ]
        }
    );

    is_deeply(
        \%index_only, \%should_be, 'tables_to_index data structure OK'
    );

    my $index_only = $search->tables_to_index('ontology');

    is( ref $index_only, 'HASH', 'tables_to_index will return hashref' );

    is_deeply(
        \%index_only, \%should_be, 'tables_to_index data structure still OK'
    );

    ok( 
        my %sql = $search->sql_to_index('ensembl_oryza_sativa_japonica.gene'),
        'got sql_to_index'
    );

    is(
        scalar @{ $sql{'gene'} }, 
        5, 
        'found 5 SQL statements for the "gene" table'
    );
}

{
    ok( my $search = Grm::Search->new( base_dir => $Bin, page_size => 25 ), 
        'new with page_size'
    );

    is( $search->page_size, 25, 'BUILD uses page_size' );
}

done_testing();
