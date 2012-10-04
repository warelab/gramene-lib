use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Gramene',
    license             => 'gpl',
    dist_abstract       => 'Gramene libraries',
    dist_author         => q{Gramene <gramene@gramene.org>},
    dist_version        => '36.0.0',
    build_requires => {
        'Test::More' => 0,
        'Test::Exports' => 0,
    },
    requires => {
        'perl'          => 5.006,
        'Data::Pageset' => 0,
        'Template'      => 0,
    },
    add_to_cleanup      => [ 'gramene-lib-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
