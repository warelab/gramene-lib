#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::Exports;
use Test::More tests => 12;

my @subs = qw[
    commify
    get_logger
    gramene_cdbi_class_to_module_name
    gramene_cdbi_class_to_table_name
    iterative_search_values
    match_context
    module_name_to_gdbic_class
    pager
    parse_words
    table_name_to_gdbic_class
];

my $class = 'Grm::Utils';

require_ok $class or BAIL_OUT "Can't load module";

import_ok $class, \@subs, 'Default import';

is_import @subs, $class, 'Imported subs';

use_ok $class;

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
    table_name_to_gdbic_class('foo_bar', 'baz_quux'),
    'Grm::DBIC::FooBar::BazQuux',
    'table_name_to_gdbic_class ok'
);
