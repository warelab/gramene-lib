#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw( say );
use autodie;
use Carp qw( croak );
use DBI;
use File::Basename;
use Getopt::Long;
use IO::Prompt qw( prompt );
use Pod::Usage;
use Readonly;
use Grm::DB;
use Grm::Config;
use Grm::DBIC::Features;
use Gramene::Utils qw( commify );
use MySQL::Config qw( parse_defaults );

my $amigo_db_host = '';
my $amigo_db_name = '';
my $amigo_db_user = '';
my $amigo_db_pass = '';
my $prompt        =  1;
my ( $help, $man_page );
GetOptions(
    'd|db=s'   => \$amigo_db_name,
    'h|host:s' => \$amigo_db_host,
    'u|user:s' => \$amigo_db_user,
    'p|pass:s' => \$amigo_db_pass,
    'prompt!'  => \$prompt,
    'help'     => \$help,
    'man'      => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

if ( !$amigo_db_name ) {
    pod2usage('No Amigo db name');
}

my $config       = Grm::Config->new;
my $db_conf      = $config->get('database');
my %my_cfg       = parse_defaults 'my', ['client'];
$amigo_db_user ||= $my_cfg{'user'};
$amigo_db_pass ||= $my_cfg{'password'};
$amigo_db_host ||= $db_conf->{'host'};

my $amigo_dbh  = DBI->connect(
    "dbi:mysql:host=$amigo_db_host;database=$amigo_db_name",
    $amigo_db_user, $amigo_db_pass, { RaiseError => 1 }
);
my $term_count = $amigo_dbh->selectrow_array('select count(*) from term');
my $fdb        = Grm::DB->new('features');

if ( $prompt ) {
    my $yn = prompt -yn, 
        sprintf("OK to load %s terms from '%s' into '%s'? [yn] ",
            commify($term_count), $amigo_db_name, $fdb->real_name
        );

    if ( !$yn ) {
        say 'Bye.';
        exit 0;
    }
}

#my $fdbh = $fdb->dbh;

my $schema = Grm::DBIC::Features->connect( sub { $fdb->dbh } );

#
# Sort out the term types, create any that Amigo has that we don't
#
my %term_types = 
    map { $_->go_term_type, $_->id }
    $schema->resultset('OntologyTermType')->search();

my $amigo_term_types = $amigo_dbh->selectcol_arrayref(
    'select distinct term_type from term'
);

for my $amigo_term_type ( @$amigo_term_types ) {
    if ( !$term_types{ $amigo_term_type } ) {
        my $pretty_name = join(' ',
            map { ucfirst }
            split( /_/, lc $amigo_term_type )
        );

        my $TermType = $schema->resultset('OntologyTermType')->create(
            term_type    => $pretty_name,
            go_term_type => $amigo_term_type,
        );

        $term_types{ $amigo_term_type } = $TermType->term_type_id;
    }
}

my $amigo_terms = $amigo_dbh->selectall_arrayref(
    q[
        select id, name, term_type, acc, is_obsolete, is_root, is_relation
        from   term
    ]
);

for my $term ( @$amigo_terms ) {
    my $term_accession = $term->{'acc'} or next;
    my $TermType       = $term_types{ $term->{'term_type'} };

    my @Terms = $schema->resultset('OntologyTerm')->search({
        ontology_term_type_id => $TermType->term_type_id,
        term_accession        => $term_accession 
    });

    my $Term;
    if ( @Terms == 1 ) {
        $Term = shift @Terms;
    }
    elsif ( @Terms < 1 ) {
        $Term = $schema->resultset('OntologyTerm')->create({
            ontology_term_type_id => $TermType->term_type_id,
            term_accession        => $term_accession 
        });
    }
    else {
        printf STDERR "Can't find %s %s\n", 
            $term->{'term_type'},
            $term->{'term_accession'},
        ;
    }

    for my $fld ( qw[ is_obsolete is_root ] ) {
        $Term->$fld( $term->{ $fld } );
    }

    $Term->update;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-from-go.pl - a script

=head1 SYNOPSIS

  load-from-go.pl 

Required:

  -d|--db     GO db name

Options:

  -h|--host   Amigo db host, default "database/host" from "gramene.conf"
  -u|--user   GO db user, default "[client]" from ".my.cnf"
  -p|--pass   GO db password, default "[client]" from ".my.cnf"

  --prompt    Ask before doing anything (default yes, kill with --no-prompt)
  --help      Show brief help and exit
  --man       Show full documentation

=head1 DESCRIPTION

Loads latest GO terms into configured ontology db.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2011 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
