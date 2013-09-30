use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name    => 'Gramene',
    license        => 'gpl',
    dist_abstract  => 'Gramene libraries',
    dist_author    => q{Gramene <gramene@gramene.org>},
    dist_version   => '37.0.0',
    build_requires => {
        'Test::More'    => 0,
        'Test::Exports' => 0,
        'Readonly'      => 0,
    },
    requires => {
        'perl'                         => 5.006,
        'Class::Load'                  => 0,
        'Data::Pageset'                => 0,
        'DBI'                          => 0,
        'DBD::mysql'                   => 0,
        'DBIx::Class'                  => 0,
        'Lucy'                         => 0,
        'LucyX::Search::WildcardQuery' => 0,
        'Log::Dispatch::File'          => 0,
        'Moose'                        => 0,
        'MooseX::Aliases'              => 0,
        'MooseX::NonMoose'             => 0,
        'namespace::autoclean'         => 0,
        'Net::Ping'                    => 0,
        'IO::Prompt'                   => 0,
        'Template'                     => 0,
        'Term::ReadKey'                => 0,
        'Time::Interval'               => 0,
        'Time::HiRes'                  => 0,
        'YAML'                         => 0,
        'Want'                         => 0,
    },
    add_to_cleanup     => ['gramene-lib-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
