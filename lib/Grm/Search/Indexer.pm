package Grm::Search::Indexer;

=head1 NAME

Grm::Search::Indexer - adds search records to the Solr index

=head1 SYNOPSIS

  use Grm::Search::Indexer;

  my $indexer = Grm::Search::Indexer->new( module => 'ensembl_zea_mays' );
  $indexer->add( [{}] );

=head1 DESCRIPTION

Description of module goes here.

=head1 SEE ALSO

perl.

=head1 AUTHOR

kclark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2013 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut

# ----------------------------------------------------

use strict;
use Carp qw( croak );
use Data::Dumper;
use Grm::Config;
use HTTP::Request;
use JSON::XS;
use LWP::UserAgent;
use Moose;
use XML::Simple qw( XMLout );

has config => (
    is  => 'ro',
    isa => 'Grm::Config',
    lazy_build => 1,
);

has module => (
    is     => 'rw',
    isa    => 'Str',
);

has lwp => (
    is         => 'rw',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

has solr_url => (
    is     => 'rw',
    isa    => 'Str',
    lazy_build => 1,
);

# ----------------------------------------------------
sub BUILD {
    my ( $self, $args ) = @_;
    my $module = $self->module( $args->{'module'} ) or croak 'No module';
}

# ----------------------------------------------------
sub _build_solr_url {
    my $self     = shift;
    my $config   = $self->config->get('search'); 
    my $solr_url = $config->{'solr'}{'url'} or die 'No Solr URL';
    return $solr_url;
}

# ----------------------------------------------------
sub _build_config {
    return Grm::Config->new;
}

# ----------------------------------------------------
sub _build_lwp {
    my $self = shift;
    my $ua   = LWP::UserAgent->new;
    $ua->agent('GrmSearchLoadr/0.1');

    return $ua;
}

# ----------------------------------------------------
sub _build_module {
    my $self   = shift;
    my $module = shift or return;

    ( $module = lc $module ) =~ s/\s+/_/g;

    return $module;
}

# ----------------------------------------------------
sub add {
    my $self     = shift;
    my @data = ref $_[0] eq 'ARRAY' ? @{ $_[0] } : @_;

    return unless @data;

    my $solr_url = $self->solr_url;
    my $config   = $self->config->get('search'); 
    my @flds     = @{ $config->{'solr'}{'load_fields'} || [] } 
                   or croak 'No Solr load_fields';

    for my $doc ( @data ) {
        for my $fld ( @flds ) {
            if ( defined $doc->{ $fld } && !ref $doc->{ $fld } ) {
                $doc->{ $fld } =~ s/[^[:ascii:]]//g;
            }
        }
    }

    my $req = HTTP::Request->new( POST => $solr_url . '/update?commit=true' );

    $req->content_type('application/json');
    $req->content( encode_json( \@data ) );

    my $ua  = $self->lwp;
    my $res = $ua->request( $req );

    if ( $res->is_success ) {
        return 1;
    }
    else {
        croak $res->status_line;
    }
}

# ----------------------------------------------------
sub commit {
    return 1;
}

# ----------------------------------------------------
sub truncate {
    my $self   = shift;
    my $module = $self->module or die 'No module';
    my $config = $self->config->get('search'); 
    my $url    = $config->{'solr'}{'url'} or croak 'No Solr URL';
    my $req    = HTTP::Request->new( POST => $url . '/update?commit=true' );

    $req->content_type('application/xml');
    $req->content("<delete><query>module:$module</query></delete>");

    my $res = $self->lwp->request($req);

    if ( $res->is_success ) {
        return 1;
    }
    else {
        croak $res->status_line;
    }
}

# ----------------------------------------------------
sub add_meta {
    return 1;
}

1;
