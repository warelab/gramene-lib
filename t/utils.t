#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::Exports;
use Test::More tests => 18;

my @subs = qw[
    camel_case
    commify
    extract_ontology
    get_logger
    gramene_cdbi_class_to_module_name
    gramene_cdbi_class_to_table_name
    iterative_search_values
    module_name_to_gdbic_class
    pager
    parse_words
    table_name_to_gdbic_class
    timer_calc
    url_to_obj
];

my $class = 'Grm::Utils';

require_ok $class or BAIL_OUT "Can't load module";

import_ok $class, \@subs, 'Default import';

is_import @subs, $class, 'Imported subs';

use_ok $class;

#
# camel_case
#
is( camel_case('foo_bar'), 'FooBar', 'camel_case OK' );

#
# commify
#
is( commify('1234567890'), '1,234,567,890', 'commify OK' );

#
# get_logger
#

#
# gramene_cdbi_class_to_module_name
#
is( 
    gramene_cdbi_class_to_module_name('Grm::DBIC::Maps::MarkerType'),
    'maps',
    'gramene_cdbi_class_to_module_name ok'
);

#
# gramene_cdbi_class_to_table_name
#
is( 
    gramene_cdbi_class_to_table_name('Grm::DBIC::Maps::MarkerType'),
    'marker_type',
    'gramene_cdbi_class_to_module_name ok'
);

#
# module_name_to_gdbic_class
#
is( 
    module_name_to_gdbic_class('foo_bar'),
    'Grm::DBIC::FooBar',
    'module_name_to_gdbic_class ok'
);

is( 
    module_name_to_gdbic_class('ensembl_oryza_sativa'),
    'Grm::DBIC::Ensembl',
    'module_name_to_gdbic_class ensembl ok'
);

is( 
    module_name_to_gdbic_class('diversity_rice'),
    'Grm::DBIC::Diversity',
    'module_name_to_gdbic_class diversity ok'
);

is( 
    module_name_to_gdbic_class('pathway_sorghum_bicolor'),
    'Grm::DBIC::Pathway',
    'module_name_to_gdbic_class pathway ok'
);

#
# table_name_to_gdbic_class
#
is( 
    join( ' ', table_name_to_gdbic_class('foo_bar', 'baz_quux') ),
    'Grm::DBIC::FooBar BazQuux',
    'table_name_to_gdbic_class ok'
);

#
# timer_calc
#

my $t0 = timer_calc( [1350330619, 481395] );
my $r0 = $t0->( [1350330619, 481395] );
is( 
    $r0,
    '0 seconds',
    "timer_calc: $r0"
);

my $t1 = timer_calc( [1350330619, 481395] );
my $r1 = $t1->( [1350330620, 481395] );
is( 
    $r1,
    '1 second',
    "timer_calc: $r1"
);

my $t2 = timer_calc( [1350330619, 481395] );
my $r2 = $t2->( [1350330621, 481395] );
is( 
    $r2,
    '2 seconds',
    "timer_calc: $r2"
);

my $t3 = timer_calc( [1350330619, 481395] );
my $r3 = $t3->( [1350390621, 481395] );
is( 
    $r3,
    '16h 40m 2s',
    "timer_calc: $r3"
);

#
# iterative_search_values
#
my @vals = iterative_search_values('foo');
is_deeply(
    \@vals,
    [ 'foo', 'foo*', '*foo*' ],
    'iterative_search_values ok'
);
