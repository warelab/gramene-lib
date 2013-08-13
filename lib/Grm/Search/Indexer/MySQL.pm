package Grm::Search::Indexer::MySQL;

=head1 NAME

Grm::Search::Indexer::MySQL - a Gramene module

=head1 SYNOPSIS

  use Grm::Search::Indexer::MySQL;

=head1 DESCRIPTION

Description of module goes here.

=head1 SEE ALSO

perl.

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

# ----------------------------------------------------

use strict;
use Moose;
use Carp qw( croak );
use DBI;

has module => (
    is     => 'rw',
    isa    => 'Str',
);

has schema => (
    is      => 'ro',
    isa     => 'Str',
    default => q[
        CREATE TABLE IF NOT EXISTS search (
          search_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
          url varchar(255) NOT NULL DEFAULT '',
          title varchar(255) NOT NULL DEFAULT '',
          taxonomy varchar(255) NOT NULL DEFAULT '',
          ontology text,
          content text,
          FULLTEXT KEY ontology (ontology),
          FULLTEXT KEY content (content)
        ) ENGINE=MyISAM;

        CREATE TABLE IF NOT EXISTS meta (
          meta_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
          meta_name varchar(255) NOT NULL DEFAULT '',
          meta_value varchar(255) NOT NULL DEFAULT '',
          UNIQUE (meta_name)
        ) ENGINE=MyISAM;
    ],
);

has dbh => (
    is  => 'rw',
);

has config => (
    is  => 'ro',
    isa => 'Grm::Config',
    lazy_build => 1,
);

# ----------------------------------------------------
sub BUILD {
    my ( $self, $args ) = @_;

    my $module       = $self->module( $args->{'module'} ) or croak 'No module';
    my $db_name      = 'grm_search_' . $module;
    my $mysql_config = $self->config->get('mysql');
    my $mysqlshow    = $mysql_config->{'mysqlshow'};
    my $mysql_args   = join( ' ',
        '-h', $mysql_config->{'host'},
        '-u', $mysql_config->{'admin_user'},
        q{-p'} . $mysql_config->{'admin_password'} . q{'},
    );

    #
    # See if this exists
    #
    my @dbs = `$mysqlshow $mysql_args`;
    if ( @dbs ) {
        splice @dbs, 0, 3;  # remove headers
        splice @dbs, -1, 1; # remove footer
    }

    # extract db names
    my %exists = map { $_, 1 } map { chomp; s/^\|\s*|\s*\|//g; $_ } @dbs; 

    if ( !$exists{ $db_name } ) {
        my $mysqladmin = join ' ', $mysql_config->{'mysqladmin'}, $mysql_args;
        `$mysqladmin create $db_name`;
    }

    my $dbh = DBI->connect(
        "dbi:mysql:host=$mysql_config->{host};database=$db_name",
        $mysql_config->{'admin_user'},
        $mysql_config->{'admin_password'},
        { RaiseError => 1 }
    );

    my %table = map { $_, 1 } @{ $dbh->selectcol_arrayref('show tables') };

    if ( !$table{'search'} ) {
        my @sql = split /;/, $self->schema;

        for my $sql ( @sql ) {
            if ( $sql =~ /\w+/ ) {
                $dbh->do( $sql );
            }
        }
    }

    $self->dbh( $dbh );
}

# ----------------------------------------------------
sub _build_config {
    return Grm::Config->new;
}

# ----------------------------------------------------
sub _build_module {
    my $self   = shift;
    my $module = shift or return;

    ( $module = lc $module ) =~ s/\s+/_/g;

    return $module;
}

# ----------------------------------------------------
sub add_doc {
    my $self = shift;
    my %rec  = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $dbh  = $self->dbh; 
    my @flds = qw( url title taxonomy ontology content );
    my @vals = map { s/[^[:ascii:]]//g; $_ } map { $rec{ $_ } } @flds;
    my $sql  = sprintf(
        'insert into search (%s) values (%s)',
        join(', ', @flds), 
        join(', ', map { '?' } @flds), 
    );

    $dbh->do( $sql, {}, @vals );
}

# ----------------------------------------------------
sub commit {
    return 1;
}

# ----------------------------------------------------
sub truncate {
    my $self = shift;
    my $dbh  = $self->dbh;
    $dbh->do('truncate table search');
}

# ----------------------------------------------------
sub add_meta {
    my $self = shift;
    my %args = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $dbh  = $self->dbh;

    while ( my ( $key, $value ) = each %args ) {
        $dbh->do(
            'replace into meta (meta_name, meta_value) values (?,?)',
            {},
            ( $key, $value )
        );    
    }
}

1;
