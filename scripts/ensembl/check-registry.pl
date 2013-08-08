#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dumper;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils 'commify';
use List::Util 'max';
use Pod::Usage;
use Readonly;

my ( $help, $man_page );
GetOptions(
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $gconf       = Grm::Config->new;
my $grm_version = $gconf->get('version') or die 'No version';
my $my_conf     = $gconf->get('mysql');
my $db_conf     = $gconf->get('database');
my @ens_modules = grep { /^ensembl_/ } $gconf->get('modules');
my $ens_conf    = $gconf->get('ensembl');
my $ens_version = $ens_conf->{'version'}       or die 'No ensembl version';
my $reg_file    = $ens_conf->{'registry_file'} or die 'No registry file';

printf "\nChecking %s modules against registry file:\n- %s\n",
    commify(scalar @ens_modules), $reg_file;

my $mysqlshow = $my_conf->{'mysqlshow'} or die 'No mysqlshow';
my $host      = $my_conf->{'host'}      || 'localhost';
my @cores     = 
    map  { (split( /\s+/, $_ ))[1] }
    grep { /_core_${grm_version}_${ens_version}_/ } `$mysqlshow -h $host`;

my %core_name;
for my $core ( @cores ) {
    my ( $species, $grm_ver, $ens_ver, $genome_version ) =
        ( $core =~ /(\w+)_core_(\d+)_(\d+)_(\w+)/ ) or 
    do {
        print "Core db '$core' doesn't look right, skipping.\n";
        next;
    };

    if ( my $ver1 = $core_name{ $species } ) {
        if ( 
            $ver1->{'genome_version'} =~ /^\d+$/ &&
            $genome_version           =~ /^\d+$/ 
        ) {
            next if $ver1->{'genome_version'} > $genome_version;
        }
    }

    $core_name{ $species } = {
        grm_version      => $grm_ver,
        ens_version      => $ens_ver,
        genome_version   => $genome_version,
        core_name        => $core,
    };
}

printf "\nFound %s Ensembl cores for version %s\n\n", 
    commify(scalar keys %core_name), $grm_version;

my $i;
for my $module ( @ens_modules ) {
    my $db = Grm::DB->new( $module );
    printf "%3s: %s\n", ++$i, $module;

    my $indent = '    - ';
    my $report = sub { say $indent, @_ };
    my $error  = sub { say STDERR $indent, 'ERROR: ', @_ };

    if ( $db->host eq $db_conf->{'default'}{'host'} ) {
        $report->(sprintf('host ok (%s)', $db->host));
    }
    else {
        $error->(sprintf( "%s host (%s) not the default (%s)\n",
            $module, $db->host, $db_conf->{'default'}{'host'}
        ));
    }

    ( my $species = $module ) =~ s/^ensembl_//;
    my $core_info = $core_name{ $species } or do {
        $error->("No core name like '$species'");
        next;
    };

    my $latest_core = $core_info->{'core_name'} or do {
        $error->("No core for '$species'");
        next;
    };

    if ( $db->real_name eq $latest_core ) {
        $report->(sprintf('db name ok (%s)', $db->real_name));
    }
    else {
        $error->(sprintf( "%s db name (%s) not the latest (%s)",
            $module, $db->real_name, $latest_core
        ));
    }

    my $schema_version = $db->dbh->selectrow_array(
        'select meta_value from meta where meta_key="schema_version"'
    );

    if ( $schema_version == $ens_version ) {
        $report->("schema version ok ($schema_version)");
    }
    else {
        $error->(sprintf("%s db version %s different from Ensembl version (%s)",
            $db->real_name, $schema_version, $ens_version
        ));
    }
}

say 'Done.';

__END__

# ----------------------------------------------------

=pod

=head1 NAME

check-registry.pl - a script

=head1 SYNOPSIS

  check-registry.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2013 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
