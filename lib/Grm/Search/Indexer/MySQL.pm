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
        CREATE TABLE search (
          search_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
          url varchar(255) NOT NULL DEFAULT '',
          title varchar(255) NOT NULL DEFAULT '',
          category varchar(255) NOT NULL DEFAULT '',
          taxonomy varchar(255) NOT NULL DEFAULT '',
          ontology text,
          content text,
          FULLTEXT KEY ontology (ontology),
          FULLTEXT KEY content (content)
        ) ENGINE=MyISAM 
    ],
);

has dbh => (
    is  => 'rw',
);

# ----------------------------------------------------
sub BUILD {
    my ( $self, $args ) = @_;

    my $module      = $self->module( $args->{'module'} ) or croak 'No module';
    my $db_name     = 'grm_search_' . $module;
    my $host        = 'cabot';
    my $mysql_admin = "/usr/local/mysql/bin/mysqladmin -h $host";

    eval { `$mysql_admin drop -f $db_name` };
    `$mysql_admin create $db_name`;

    my $dbh = DBI->connect(
        "dbi:mysql:host=$host;database=$db_name",
        'kclark',
        'g0p3rl!',
        { RaiseError => 1 }
    );

    $dbh->do( $self->schema );

    $self->dbh( $dbh );
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
    my @flds = qw( url title category taxonomy ontology content );
    my $sql  = sprintf(
        'insert into search (%s) values (%s)',
        join(', ', @flds), 
        join(', ', map { '?' } @flds), 
    );

    $dbh->do( $sql, {}, map { $rec{ $_ } } @flds );
}

# ----------------------------------------------------
sub commit {
    return 1;
}

1;
