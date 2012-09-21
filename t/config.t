#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec::Functions;
use Test::Exception;
use Test::More tests => 22;

my $test_conf_file  = catfile( $Bin, 'data', 'gramene.conf.test'  );
my $alt_conf_file   = catfile( $Bin, 'data', 'gramene.conf.alt'   );
my $empty_conf_file = catfile( $Bin, 'data', 'gramene.conf.empty' );
my $bad_conf_file   = catfile( $Bin, 'data', 'gramene.conf.bad'   );

use_ok('Grm::Config');

# Default path 
{
    my $conf = new_ok('Grm::Config');

    is( $conf->filename, $conf->default_filename,
        "Default filename is '" . $conf->default_filename ."'"
    );

    $conf->filename( $alt_conf_file );
    is( $conf->filename, $alt_conf_file, "Changed to '$alt_conf_file'" );

    my $config_obj = $conf->config_object;
    ok( $config_obj, 'Got the config object' );
    isa_ok( $config_obj, 'Config::General', '...and it\'s a Config::General' );

    my $conf_hash = $conf->config;
    ok( $conf_hash, 'Got the config' );
    isa_ok( $conf_hash, 'HASH', 'config is a HASH' );
    is( $conf_hash->{'main'}{'model'}, 'flying_v', 'Found the Flying V' );

    $conf->filename( $test_conf_file );
    is( $conf->filename, $test_conf_file, "Change OK to '$test_conf_file'" );

    $conf_hash = $conf->config;
    is( $conf_hash->{'main'}{'model'}, undef,
        'Config hash gets cleared on filename reset' 
    );

    is( $conf_hash->{'prefs'}{'favorite_color'}, 'blue', 
        'New config hash looks good'
    );

    $conf->clear_config;
    is( $conf->has_config, '', 'clear_config works' );

    throws_ok( sub { $conf->filename('foo.bar') },
        qr/does not pass the type constraint/, 'Dies on bad filename'
    );

    throws_ok( sub { $conf->filename( $empty_conf_file ) },
        qr/does not pass the type constraint/, 'Dies on empty file'
    );

    
    $conf->clear_filename;

    is( $conf->has_filename, '', 'filename cleared, predicate method works' );

    my $prefs = $conf->get('prefs');
    isa_ok( $prefs, 'HASH', '"prefs"' );

    is( $prefs->{'favorite_color'}, 'blue', 
        'Blue is the favorite color, no, wait, red -- aaaaaaaah!'
    );

    is_deeply( $conf->config, $conf->getall, '"getall" is alias for "config"' );
}

# Config path from argument
{
    my $conf = Grm::Config->new( filename => $test_conf_file );
    is( $conf->filename, $test_conf_file, 
        "New uses given filename '$test_conf_file'" 
    );
}

# Config path from single argument (old Gramene::Config style)
{
    my $conf = Grm::Config->new( $test_conf_file );
    is( $conf->filename, $test_conf_file, "New works with single arg" );
}

# Config path from $ENV
{
    $ENV{'GrameneConfPath'} = $test_conf_file;
    my $conf = Grm::Config->new;
    is( $conf->filename, $ENV{'GrameneConfPath'},
        "New uses \$ENV '$ENV{GrameneConfPath}'"
    );
}
