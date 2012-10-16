#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
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
use Grm::Utils qw( commify timer_calc camel_case );
use MySQL::Config qw( parse_defaults );

my %COL_MAP    = (
    dbxref          => { id => 'dbxref_id' },
    graph_path      => { id => 'graph_path_id' },
    term_definition => { term_definition => 'definition' },
);

my $amigo_db_host = '';
my $amigo_db_name = '';
my $amigo_db_user = '';
my $amigo_db_pass = '';
my $force         =  0;
my ( $help, $man_page );
GetOptions(
    'd|db=s'   => \$amigo_db_name,
    'h|host:s' => \$amigo_db_host,
    'u|user:s' => \$amigo_db_user,
    'p|pass:s' => \$amigo_db_pass,
    'force'    => \$force,
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
$amigo_db_host ||= $db_conf->{'default'}{'host'};

my $amigo_dbh  = DBI->connect(
    "dbi:mysql:host=$amigo_db_host;database=$amigo_db_name",
    $amigo_db_user, $amigo_db_pass, { RaiseError => 1 }
);
my $term_count = $amigo_dbh->selectrow_array('select count(*) from term');
my $odb        = Grm::DB->new('ontology');

unless ( $force ) {
    my $yn = prompt -yn, 
        sprintf("OK to load %s terms from '%s' into '%s'? [yn] ",
            commify($term_count), $amigo_db_name, $odb->real_name
        );

    if ( !$yn ) {
        say 'Bye.';
        exit 0;
    }
}

my $timer  = timer_calc();
my $schema = $odb->dbic;

#
# Sort out the term types, create any that Amigo has that we don't
#
say 'Initializing term types...';
my %term_types = 
    map { $_->term_type, $_->id }
    $schema->resultset('TermType')->search();

my $amigo_term_types = $amigo_dbh->selectcol_arrayref(
    'select distinct term_type from term'
);

for my $amigo_term_type ( @$amigo_term_types ) {
    if ( !$term_types{ $amigo_term_type } ) {
        my $pretty_name = join(' ',
            map { ucfirst }
            split( /_/, lc $amigo_term_type )
        );

        my $TermType = $schema->resultset('TermType')->create({
            term_type => $pretty_name,
            term_type => $amigo_term_type,
        });

        $term_types{ $amigo_term_type } = $TermType->term_type_id;
    }
}

say 'Gathering AmiGO terms...';
my $amigo_terms = $amigo_dbh->selectall_arrayref(
    q[
        select id, name, term_type, acc, is_obsolete, is_root, is_relation
        from   term
    ],
    { Columns => {} }
);

printf "Processing %s records in 'term'...\n", commify($term_count);

my $term_num = 0;
for my $term ( @$amigo_terms ) {
    my $term_accession = $term->{'acc'} or next;
    my $term_type_id   = $term_types{ $term->{'term_type'} };

    printf "%-70s\r", sprintf("%3s%%: %s (%s)", 
        int( $term_num/$term_count * 100 ),
        commify(++$term_num), 
        $term_accession, 
    );

    my @Terms = $schema->resultset('Term')->search({
        term_type_id   => $term_type_id,
        term_accession => $term_accession,
    });

    my $Term;
    if ( @Terms == 1 ) {
        $Term = shift @Terms;
    }
    elsif ( @Terms < 1 ) {
        $Term = $schema->resultset('Term')->create({
            term_id        => $term->{'id'},
            term_type_id   => $term_type_id,
            term_accession => $term_accession 
        });
    }
    else {
        printf STDERR "Can't find %s %s\n", 
            $term->{'term_type'},
            $term->{'term_accession'},
        ;
    }

    for my $fld ( qw[ name is_obsolete is_root ] ) {
        $Term->$fld( $term->{ $fld } );
    }

    $Term->update;
}

print "\n";

#
# Relationship types
#
my $rt_ids = $amigo_dbh->selectcol_arrayref(
    'select distinct relationship_type_id from term2term'
);

my $rt_count = scalar @$rt_ids;
printf "Processing %s in 'relationship_type'\n", commify($rt_count);

my $i      = 0;
my $rel_rs = $schema->resultset('RelationshipType');
my %relationship_type_id;
for my $relationship_type_id ( @$rt_ids ) {
    my $type = $amigo_dbh->selectrow_array(
        'select acc from term where id=?', {}, $relationship_type_id
    );

    $i++;
    printf "%-70s\r", sprintf('%3s%%: %s (%s)', 
        int( $i/$rt_count * 100 ),
        commify($i),
        $type,
    );

    my $rt = $rel_rs->find_or_create({ type_name => $type });
    $relationship_type_id{ $type } = $rt->id;
}

print "\n";

#
# Term to Term
#
my $term_to_term = $amigo_dbh->selectall_arrayref(
    'select * from term2term', { Columns => {} }
);

my $term_to_term_count = scalar @$term_to_term;
printf "Processing %s records in 'term2term'\n", commify($term_to_term_count);

my $t2t_rs = $schema->resultset('TermToTerm');
$i = 0;
for my $t2t ( @$term_to_term ) {
    $i++;
    printf "%-70s\r", sprintf('%3s%%: %s', 
        int( $i/$term_to_term_count * 100 ),
        commify($i),
    );

    my $rel_type = $amigo_dbh->selectrow_array(
        'select acc from term where id=?', {}, $t2t->{'relationship_type_id'}
    );

    my $rt_id = $relationship_type_id{ $rel_type } or die 'No RT';
    my $res   = $rel_rs->find_or_create(
        relationship_type_id => $rt_id,
        term1_id             => $t2t->{'term1_id'},
        term2_id             => $t2t->{'term2_id'},
    );
}

print "\n";

#
# All the rest...
#
my @tables = qw(
    dbxref term_dbxref term_definition term_synonym graph_path
);

for my $table ( @tables ) {
    my $result_set    = $schema->resultset( camel_case($table) );
    my $result_source = $result_set->result_source;
    my %gr_col        = map { $_, 1 } $result_source->columns;
    my @amigo_cols    = map { $_->{'Field'} }
        @{ $amigo_dbh->selectall_arrayref("desc $table", { Columns => {} } ) }
    ;

    my @select_cols;
    for my $amigo_col ( @amigo_cols ) {
        if ( my $alias = $COL_MAP{ $table }{ $amigo_col } || '' ) {
            push @select_cols, "$amigo_col as $alias"
        }
        elsif ( $gr_col{ $amigo_col } ) {
            push @select_cols, $amigo_col;
        }
    }

    my $data = $amigo_dbh->selectall_arrayref(
        sprintf( 'select %s from %s', join(',', @select_cols), $table ),
        { Columns => {} }
    );

    my $total = scalar @$data;
    printf "Processing %s records in '%s'\n", commify($total), $table;

    my $i = 0;
    for my $rec ( @$data ) {
        $i++;
        printf "%-70s\r", 
            sprintf('%3s%%: %s', int($i/$total * 100), commify($i));

        my %def = map { $_, $rec->{ $_ } } keys %gr_col;
        $result_set->find_or_create( \%def );
    }

    print "\n";
}

printf "Done, processed %s terms in %s.\n", 
    $term_count, $timer->();

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-from-go.pl - loads the Gramene "ontologyXX" db from the "amigoXX" db

=head1 SYNOPSIS

  load-from-go.pl 

Required:

  -d|--db     GO db name

Options:

  -h|--host   Amigo db host, default "database/host" from "gramene.conf"
  -u|--user   GO db user, default "[client]" from ".my.cnf"
  -p|--pass   GO db password, default "[client]" from ".my.cnf"

  --force     Don't prompt for OK
  --help      Show brief help and exit
  --man       Show full documentation

=head1 DESCRIPTION

Loads latest GO terms into configured ontology db.

=head1 SEE ALSO

AmiGO/Gene Ontology.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
