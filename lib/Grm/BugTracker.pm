package Grm::BugTracker;

# $Id: BugTracker.pm 14372 2010-04-28 15:20:24Z thomason $

=head1 NAME

Grm::BugTracker - a Gramene module

=head1 SYNOPSIS

  use Grm::BugTracker;

  my $bug_tracker = Grm::BugTracker->new;
  $bug_tracker->set_project('Public Gramene Feedback');
  my @categories = @{ $bug_tracker->get_categories };
  $bug_tracker->complain(
      'summary'     => 'Fix this module',
      'description' => 'This module sucks',
      'category'    => 'Modules',
  );
  
=head1 DESCRIPTION

A generic interface for programmatic submission of bugs/issues into
the bug-tracker (specifically, Mantis). Uses SOAP to contact the
Mantis SOAP API on the server to create the bug.

A project is required to be associated with the module, though a default
project

=head1 SEE ALSO

    <a href="http://www.mantisbt.org">Mantis Bug Tracker</a>
    <a href="http://futureware.biz/mantisconnect">MantisConnect</a>
    SOAP::Lite

=head1 AUTHOR

Shiran Pasternak E<lt>shiran@cshl.eduE<gt>,
Apurva Narechania E<lt>apurva@cshl.eduE<gt>,
Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut

# ----------------------------------------------------

use strict;
use warnings;
use Carp qw( croak );
use Data::Dumper;
use SOAP::Lite;
use Readonly;

Readonly my $SOAP_PROXY      =>
    'http://warelab.org/bugs/api/soap/mantisconnect.php';
Readonly my $SOAP_NAMESPACE  => 'http://futureware.biz/mantisconnect';
Readonly my $MANTIS_USERNAME => 'gramene_feedback';
Readonly my $MANTIS_PASSWORD => 'oh.rye.zuh';
Readonly my $DEFAULT_PROJECT => 'Public Gramene Feedback';

# ----------------------------------------------------
sub new {

=pod

=head2 new

  my $tracker = Grm::BugTracker->new;

=cut

    my $class = shift;
    my %param = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $self  = bless {}, $class;

    $self->set_project( $param{'project'} || $DEFAULT_PROJECT );

    return $self;
}

# ----------------------------------------------------
sub soap {

=pod

=head2 soap

  my $soap = $tracker->soap;

Initializes, returns the SOAP object

=cut

    my $self = shift;

    if (!defined $self->{'soap'}) {
        $self->{'soap'}
            = SOAP::Lite->uri($SOAP_NAMESPACE)->proxy($SOAP_PROXY);
    }

    return $self->{'soap'};
}


# ----------------------------------------------------
sub _invoke_auth {

=pod

=head2 _invoke_auth

    Wraps around the method to ensure it could be called

=cut

    my ($self, $method_name, @arguments) = @_;
    my $soap = $self->soap;
    my $call = $soap->$method_name(
        $MANTIS_USERNAME, $MANTIS_PASSWORD, @arguments
    );

    if ( $call->fault ) {
        croak( 
            sprintf(
                'Error %s: %s for method %s', 
                $call->faultcode, $call->faultstring, $method_name
            )
        );
    }

    return $call->result;
}

# ----------------------------------------------------
sub set_project {

=pod

=head2 set_project

  $tracker->set_project('Foo');

Finds an accessible Mantis project and sets it. Dies if project cannot be
found.

=cut

    my $self         = shift;
    my $project_name = shift or return;
    my %project      = map { $_->{'name'}, $_ } @{ 
        $self->_invoke_auth('mc_projects_get_user_accessible') 
    };

    if ( my $project = $project{ $project_name } ) {
        $self->{'_project'} = $project;
    }
    else {
        croak( "Unable to find BugTracker project '$project_name'" );
    }

    return 1;
}

# ----------------------------------------------------
sub get_project {

=pod

=head2 get_project

  my $current_project = $tracker->get_project;

Returns the project

=cut

    return $_[0]->{'_project'};
}

# ----------------------------------------------------
sub complain {

=pod

=head2 complain

  my $bug_number = $tracker->complain(
      'summary'     => 'Fix this module',
      'description' => 'This module sucks',
      'category'    => 'Modules',
  );

Creates a new issue.

=cut

    my $self  = shift;
    my %param = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;

    my @issue_data = (
        [ 'summary',     $param{'summary'},     'string'      ],
        [ 'description', $param{'description'}, 'string'      ],
        [ 'category',    $param{'category'},    'string'      ],
        [ 'project',     $self->get_project,    'ProjectData' ],
    );

    # TODO: This needs to be a lot simpler
    my @array = map { 
        SOAP::Data->name($_->[0] => $_->[1])->type($_->[2]) 
    } @issue_data;

    my $issue = SOAP::Data->name(
        IssueData =>
            \SOAP::Data->value(SOAP::Data->value(@array)->type('IssueData'))
    )->type('IssueData');

    my $issue_number = $self->_invoke_auth( 'mc_issue_add', $issue );

    if ( $param{'debug'} ) {
        print STDERR "Issue #$issue_number submitted to Mantis\n";
    }

    return $issue_number;
}

# ----------------------------------------------------
sub get_categories {

=pod

=head2 get_categories

  my @cats = $tracker->get_categories;

Returns a list of categories for the project.

=cut

    my $self = shift;

    return $self->_invoke_auth(
        'mc_project_get_categories', $self->get_project->{'id'}
    );
}

1;
