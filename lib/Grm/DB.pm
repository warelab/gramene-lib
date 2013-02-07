package Grm::DB;

use namespace::autoclean;
use Moose;
use Carp 'croak';
use Class::Load qw( load_class );
use DBI;
use Grm::Config;
use Grm::Utils qw( module_name_to_gdbic_class );
use MooseX::Aliases;
use Net::Ping;

has db_name    => (
    is         => 'rw',
    isa        => 'Str',
    alias      => [ qw( db name ) ],
    lazy_build => 1,
);

has real_name  => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has db_options => (
    is         => 'rw',
    isa        => 'HashRef',
    default    => sub { { RaiseError => 1 } },
);

has dbd => (
    is         => 'rw',
    isa        => 'Str',
    default    =>  'mysql',
    predicate  => 'has_dbd',
);

has dbh => (
    is         => 'rw',
    isa        => 'DBI::db',
    lazy_build => 1,
);

has dsn => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has dbic => (
    is         => 'ro',
    isa        => 'DBIx::Class::Schema',
    alias      => [ 'schema' ],
    lazy_build => 1,
);

has user => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has password   => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has host       => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has config     => (
    is         => 'rw',
    isa        => 'Grm::Config',
    lazy_build => 1,
);

#
# Allow for calling "->new('features')" like old Gramene::DB
#
around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if ( @_ == 1 && !ref $_[0] ) {
        return $class->$orig( db_name => $_[0] );
    }
    else {
        return $class->$orig(@_);
    }
};

# ----------------------------------------------------------------
sub BUILD {
    my $self        = shift;
    my $db_name     = $self->db_name;
    my $all_db_conf = $self->config->get('database');
    my $db_conf     = $all_db_conf->{ $db_name } or croak(
        sprintf('Unknown database "%s" in config "%s"', 
           $db_name, $self->config->filename
        )
    );

    my $default_db_conf = $all_db_conf->{'default'} || {};

    if ( my $real_name = $db_conf->{'name'} ) {
        $self->real_name( $real_name );
    }
    else {
        croak('No db "name" defined in database config');
    }

    if ( ! $self->has_user ) {
        $self->user( $db_conf->{'user'} || $default_db_conf->{'user'} || '' );
    }

    if ( ! $self->has_password ) {
        $self->password( 
            $db_conf->{'pass'}             || 
            $db_conf->{'password'}         || 
            $default_db_conf->{'password'} || 
            ''
        );
    }

    if ( ! $self->has_host ) {
        $self->host( $db_conf->{'host'} || $default_db_conf->{'host'} || '' );
    }

    if ( ! $self->has_dbd ) {
        $self->dbd( 
            $db_conf->{'dbd'}         || 
            $default_db_conf->{'dbd'} || 
            $self->default_dbd
        )
    }

    if ( !$self->has_dsn ) { 
        my $host      = $self->host;
        my $real_name = $self->real_name;
        $self->dsn(
            sprintf( "dbi:%s:%s",
                $self->dbd,
                $host ? "database=$real_name;host=$host" : $real_name
            )
        );
    }
}

# ----------------------------------------------------
#sub DEMOLISH {
#    my $self = shift;
#
#    if ( my $dbh = $self->dbh ) {
#        $dbh->disconnect;
#    }
#}

# ----------------------------------------------------------------
sub _build_config {
    return Grm::Config->new;
}

# ----------------------------------------------------------------
sub _build_dbh {
    my $self           = shift;
    my $db_name        = $self->db_name;
    my $dsn            = $self->dsn;
    my $user           = $self->user;
    my $host           = $self->host;
    my $password       = $self->password;
    my $real_name      = $self->real_name;
    my $connect_method = $ENV{'MOD_PERL'} ? 'connect' : 'connect_cached';

    my $dbh;
    eval {
        my $ping = Net::Ping->new;

        if ( $ping->bind( $host ) ) {
            $dbh = DBI->$connect_method(
                $dsn, $user, $password, $self->db_options
            );
        }
        else {
            die "Cannot find db host ($host)";
        }
    };

    if ( my $err = $@ ) {
        die "Error: $err";
    }
    else {
        return $dbh;
    }
}

# ----------------------------------------------------------------
sub _build_dbic {
    my $self    = shift;
    my $db_name = $self->db_name;
    my $class   = Grm::Utils::module_name_to_gdbic_class( $db_name );

    if ( load_class( $class ) ) {
        return $class->connect( sub { $self->dbh } );
    }
    else {
        croak "Can't load '$class'\n";
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

# ----------------------------------------------------------------

=pod

=head1 NAME

Grm::DB - connect to a Gramene database

=head1 SYNOPSIS

  use Grm::DB;
  my $db = Grm::DB->new('features');

  my $db = Grm::DB->new( 
      db_name  => '...',
      dsn      => '...',
      dbd      => '...',
      host     => '...',
      user     => '...', 
      password => '...',
  );

  my $dbh = $db->dbh;
  $dbh->selectall_arrayref( ... );

=head1 DESCRIPTION

This module read information from Grm::Config and provides a DBI db handle.

The <database> section of "gramene.conf" should have a <section> 
for the symbol passed in (e.g., "features") which defineds a real "name"
for the db (e.g., "features34").  Either in the <database> or
the specific <section> should define "host," "user," "password," 
and/or "dsn."  The default "dbd" (database driver) is "mysql" but can 
be overridden by the config file.

=head1 SEE ALSO

Gramene::Utils, DBI.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.orgE<gt>.

=head1 COPYRIGHT

Copyright (c) 2011 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for 
additional warranty disclaimers.

=cut
