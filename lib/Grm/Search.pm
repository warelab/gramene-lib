package Grm::Search;

=head1 NAME

Grm::Search - a Gramene module

=head1 SYNOPSIS

  use Grm::Search;

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
use warnings;
use namespace::autoclean;

use Moose;
use Carp;
use CGI;
use List::Util qw( max min );
use POSIX qw( ceil );
use Encode qw( decode );
use File::Find::Rule;
use File::Spec::Functions qw( catdir );
use Grm::Config;
use Lucy::Search::IndexSearcher;
use Lucy::Highlight::Highlighter;
use Lucy::Search::QueryParser;
use Lucy::Search::TermQuery;
use Lucy::Search::ANDQuery;
use LucyX::Search::WildcardQuery;
use Time::HiRes qw( gettimeofday tv_interval );

has index_path => (
    is         => 'rw',
);

has page_size  => (
    is         => 'rw',
);

has schema     => (
    is         => 'rw',
    isa        => 'Lucy::Plan::Schema', 
    lazy_build => 1,
);

has indexer    => (
    is         => 'rw',
#    isa        => 'Lucy::Index::Indexer',
    lazy_build => 1,
);

# ----------------------------------------------------
sub BUILD {
    my $self  = shift;
    my $args  = shift || {};
    my $conf  = Grm::Config->new;
    my $sconf = $conf->get('search');

    my $index_path = $sconf->{'index_path'};
    if ( $index_path !~ m{^/} ) {
        $index_path = catdir( 
            $args->{'base_dir'} || $conf->get('base_dir'), 
            $index_path 
        );
    }    

    $self->index_path( $index_path );

    $self->page_size( $args->{'page_size'} || $sconf->{'page_size'} || 10 );
}

# ----------------------------------------------------
sub _build_schema {
    my $self         = shift;
    my $schema       = Lucy::Plan::Schema->new;
    my $polyanalyzer = Lucy::Analysis::PolyAnalyzer->new( language => 'en' );

    $schema->spec_field( 
        name => 'category', 
        type => Lucy::Plan::StringType->new,
    );

    $schema->spec_field( 
        name => 'content',  
        type => Lucy::Plan::FullTextType->new(
            analyzer      => $polyanalyzer,
            highlightable => 1,
        ),
    );

    $schema->spec_field( 
        name => 'url',      
        type => Lucy::Plan::StringType->new( indexed => 0, ),
    );

    return $schema;
}

# ----------------------------------------------------
sub _build_indexer {
    my $self   = shift;
$DB::single = 1;
    my $module = shift || '';# or croak 'No module name';
    my $path   = catdir $self->index_path, $module;

    # Create an Indexer object.
    my $indexer = Lucy::Index::Indexer->new(
        schema   => $self->schema,
        index    => $path,
        create   => 1,
        truncate => 1,
    ) or croak "No indexer\n";

    return $indexer;
}

# ----------------------------------------------------
sub search {
    my $self       = shift;
    my $start_time = [ gettimeofday() ];
    my %args       = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $q          = $args{'query'}    or return;
    my $offset     = $args{'offset'}   ||  0;
    my $category   = $args{'category'} || '';
    my $limit      = $args{'limit'}    ||  0;
    my $page_size  = $args{'nopage'} 
                   ? undef 
                   : $args{'page_size'} || $self->page_size;
    my $index_path = $self->index_path;

    my $hit_count = 0;
    my @dirs      = 
      File::Find::Rule->directory()->maxdepth(1)->mindepth(1)->in($index_path);

    my @hits;
    DIR:
    for my $dir ( @dirs ) {
        my $searcher;
        eval {
            $searcher = Lucy::Search::IndexSearcher->new( index => $dir );
        };

        if ( my $err = $@ ) {
            warn ">>> $dir <<<\n$err\n";
            next DIR;
        }

        my $qparser = Lucy::Search::QueryParser->new( 
            schema => $searcher->get_schema,
            fields => ['content'],
        );

        # Build up a Query.
        my $query;
        if ( $q =~ /\*/ ) {
            $query = LucyX::Search::WildcardQuery->new(
                field  => 'content',
                term   => $q,
            );
        }
        else {
            $query = $qparser->parse($q);
        }

        if ($category) {
            my $category_query = Lucy::Search::TermQuery->new(
                field => 'category', 
                term  => $category,
            );

            $query = Lucy::Search::ANDQuery->new(
                children => [ $query, $category_query ]
            );
        }

        # Execute the Query and get a Hits object.
        my $hits = $searcher->hits(
            query      => $query,
            offset     => $offset,
            num_wanted => $page_size,
        );

        next DIR if $hits->total_hits < 1;

        $hit_count += $hits->total_hits;

        # Arrange for highlighted excerpts to be created.
        my $highlighter = Lucy::Highlight::Highlighter->new(
            searcher => $searcher,
            query    => $q,
            field    => 'content'
        );

        # Create result list.
        while ( my $hit = $hits->next ) {
            push @hits, { 
                title        => $hit->{'title'},
                content      => $hit->{'content'},
                url          => $hit->{'url'},
                score        => $hit->get_score,
                pretty_score => sprintf( "%0.3f", $hit->get_score ),
                excerpt      => $highlighter->create_excerpt($hit),
            };
        }
    }

    return { 
        num_hits => scalar @hits,
        data     => \@hits, 
        time     => tv_interval( $start_time, [ gettimeofday() ] ),
    };
}

# Create html fragment with links for paging through results n-at-a-time.
# ----------------------------------------------------
sub generate_paging_info {
    my ( $query_string, $total_hits, $offset, $page_size ) = @_;
    my $escaped_q = CGI::escapeHTML($query_string);
    my $paging_info;
    if ( !length $query_string ) {
        # No query?  No display.
        $paging_info = '';
    }
    elsif ( $total_hits == 0 ) {
        # Alert the user that their search failed.
        $paging_info
            = qq|<p>No matches for <strong>$escaped_q</strong></p>|;
    }
    else {
        # Calculate the nums for the first and last hit to display.
        my $last_result = min( ( $offset + $page_size ), $total_hits );
        my $first_result = min( ( $offset + 1 ), $last_result );

        # Display the result nums, start paging info.
        $paging_info = qq|
            <p>
                Results <strong>$first_result-$last_result</strong> 
                of <strong>$total_hits</strong> 
                for <strong>$escaped_q</strong>.
            </p>
            <p>
                Results Page:
            |;

        # Calculate first and last hits pages to display / link to.
        my $current_page = int( $first_result / $page_size ) + 1;
        my $last_page    = ceil( $total_hits / $page_size );
        my $first_page   = max( 1, ( $current_page - 9 ) );
        $last_page = min( $last_page, ( $current_page + 10 ) );

        # Create a url for use in paging links.
#        my $href = $cgi->url( -relative => 1 );
#        $href .= "?q=" . CGI::escape($query_string);
#        $href .= ";category=" . CGI::escape($category);
#        $href .= ";offset=" . CGI::escape($offset);
#
#        # Generate the "Prev" link.
#        if ( $current_page > 1 ) {
#            my $new_offset = ( $current_page - 2 ) * $page_size;
#            $href =~ s/(?<=offset=)\d+/$new_offset/;
#            $paging_info .= qq|<a href="$href">&lt;= Prev</a>\n|;
#        }
#
#        # Generate paging links.
#        for my $page_num ( $first_page .. $last_page ) {
#            if ( $page_num == $current_page ) {
#                $paging_info .= qq|$page_num \n|;
#            }
#            else {
#                my $new_offset = ( $page_num - 1 ) * $page_size;
#                $href =~ s/(?<=offset=)\d+/$new_offset/;
#                $paging_info .= qq|<a href="$href">$page_num</a>\n|;
#            }
#        }
#
#        # Generate the "Next" link.
#        if ( $current_page != $last_page ) {
#            my $new_offset = $current_page * $page_size;
#            $href =~ s/(?<=offset=)\d+/$new_offset/;
#            $paging_info .= qq|<a href="$href">Next =&gt;</a>\n|;
#        }

        # Close tag.
        $paging_info .= "</p>\n";
    }

    return $paging_info;
}

1;
