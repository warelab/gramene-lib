package Grm::Search;

=head1 NAME

Grm::Search - handles indexing of search data into Solr

=head1 SYNOPSIS

  use Grm::Search;

  my $sdb = Grm::Search->new();
  $sdb->index( 'ensembl_zea_mays' );

=head1 DESCRIPTION

All the stuff for Gramene's Solr-based searching.

=head1 METHODS

=head2 config

Returns or sets the Grm::Config object

=cut

# ----------------------------------------------------

use strict;
use warnings;
use namespace::autoclean;

use CGI;
use Carp;
use DateTime;
use Encode qw( decode );
use File::Find::Rule;
use File::Path;
use File::Spec::Functions qw( catdir );
use Grm::Config;
use Grm::Maps;
use Grm::Ontology;
use Grm::Search::Indexer;
use Grm::Utils qw( 
    timer_calc commify extract_ontology camel_case iterative_search_values 
);
use JSON qw( encode_json decode_json );
use List::MoreUtils qw( uniq );
use List::Util qw( max min );
use LWP::UserAgent;
use Mojo::Util qw( trim unquote url_unescape );
use Moose;
use POSIX qw( ceil );
use Readonly;
use Time::HiRes qw( gettimeofday tv_interval );

Readonly my $ALL         => '[[all]]';
Readonly my $COMMA_SPACE => q{, };
Readonly my $EMPTY_STR   => q{};
Readonly my $SPACE       => q{ };

has config => (
    is     => 'rw',
    isa    => 'Grm::Config',
);

# ----------------------------------------------------
sub BUILD {
    my $self = shift;
    my $args = shift || {};
    my $conf = $args->{'config'} || Grm::Config->new;

    $self->config( $conf );
}

# ----------------------------------------------------
sub index {

=pod

=head2 index

  my $results = $sdb->index( $module );
  print join "\n", 
     (map { "$_ : $results->{ $_ } } qw[ num_records num_tables time ]), ''
  ;

Indexes a module, returns a hashref describing the number of 
tables and records indexed and the elapsed time.

=cut

    my $self        = shift;
    my @modules     = map { split /\s*,\s*/ } @_;
    my $sconf       = $self->config->get('search');
    my $odb         = Grm::Ontology->new;
    my $ont_pref    = join '|', uniq( $odb->get_ontology_accession_prefixes );
    my $total_timer = timer_calc();

    #
    # Gather all the ontology accessions
    #
    print "Gathering ontology terms.\n";
    my %ont_acc = ();
    {
        my $dbic    = $odb->db->dbic;
        my $term_rs = $dbic->resultset('Term');
        my $syn_rs  = $dbic->resultset('TermSynonym');
        my $take    = sub { 
            my $name = shift;
            if ( $name =~ /^((?:$ont_pref):\d+)$/ig ) {
                $ont_acc{ lc $name }++;
            }
        };
        
        while ( my $Term = $term_rs->next ) {
            $take->( $Term->term_accession );
        }

        while ( my $Syn = $syn_rs->next ) {
            $take->( $Syn->term_synonym );
        }
    }

    my ( $num_modules, $num_skipped, $num_tables, $num_records ) 
        = ( 0, 0, 0, 0 );

    for my $module ( @modules ) {
        my %tables_to_index  = $self->tables_to_index( $module );
        my %sql_to_index     = $self->sql_to_index( $module );

        my $indexer = Grm::Search::Indexer->new( module => $module );
        my $db      = Grm::DB->new( $module );
        my $dbh     = $db->dbh;
        my $schema  = $db->dbic;

        printf "Communicating with Solr at '%s'\n", $indexer->solr_url;

        print "Removing all data for '$module'\n";
        $indexer->truncate;

        my @docs;
        TABLE:
        for my $source_name ( $schema->sources ) {
            my $timer  = timer_calc();
            my $result = $schema->resultset( $source_name );
            my $source = $result->result_source;
            my $table  = $source->name;

            if ( %tables_to_index && !exists $tables_to_index{ $table } ) {
                next TABLE;
            }

            my $object_type = $tables_to_index{ $table }{'object_type'};
            my @id_fields   = $source->primary_columns;

            if ( scalar @id_fields > 1 ) {
                print STDERR 
                    "WARNING: Skipping table '$table'; ",
                    "more than 1 primary key (",
                    join( $COMMA_SPACE, @id_fields ),
                    ")\n",
                ;
                next TABLE;
            }

            my $id_field = shift @id_fields;

            if ( !$id_field ) {
                print STDERR "No PK in ${module}.${table}, skipping.\n";
                next TABLE;
            };

            my @columns;
            if ( 
                !%tables_to_index 
                || $tables_to_index{ $table }{'fields'}->[0] eq $ALL 
            ) {
                @columns = $source->columns;
            }
            else {
                my %valid = map { $_, 1 } $source->columns;
                @columns  = @{ $tables_to_index{ $table }{'fields'} };

                if ( my @bad = grep { !$valid{ $_ } } @columns ) {
                    die sprintf("Bad columns for %s: %s\n", 
                        $table, join(', ', @bad)
                    );
                }
            }

            my @other_tables 
                = @{ $tables_to_index{ $table }{'other_tables'} || [] };

            if ( scalar @columns == 0 && scalar @other_tables == 0 ) {
                print STDERR 
                  "No columns or other tables for '$source_name,' skipping.\n";
                next TABLE;
            }

            my @index_also;
            for my $other ( @other_tables ) {
                my $other_table = $other->{'table_name'};

                my @other_columns;
                if ( $other->{'fields'}[0] eq $ALL ) {
                    my $other_rs   = $schema->resultset( 
                        camel_case($other_table) 
                    );
                    @other_columns = $other_rs->result_source->columns;
                }
                else {
                    @other_columns = @{ $other->{'fields'} || [] };
                }

                push @index_also, {
                    table_name => $other_table,
                    columns    => \@other_columns,
                };
            }

            my @additional_sql = @{ $sql_to_index{ $table } || [] };
            my $count = $dbh->selectrow_array("select count(*) from $table") 
                or next;

            my $test_sub;
            while ( 
                my ( $key, $value ) = each %{ $sconf->{'table_data_test'} }
            ) {
                my ( $mod, $tbl ) = split /\./, $key;
                if ( 
                    ( $module eq $mod || $module =~ /$mod/ )
                    && $table eq $tbl
                ) {
                    $test_sub = eval "$value";
                }
            }

            printf "\rProcessing %s record%s in %s '%s.%s'\n",
                commify($count),
                $count == 1 ? '' : 's',
                $db->real_name,
                $module,
                $table,
            ;

            my $ids = $dbh->selectcol_arrayref("select $id_field from $table");

            $num_tables++;

            my $i           = 0;
            my $batch_size  = 100;
            my @batch;

            ID:
            for my $id ( @$ids ) {
                $i++;

                printf "%-70s\r", sprintf( "%3s%%: %s", 
                    int(100 * ( $i / $count )),
                    commify($i), 
                );

                my $rec = $result->find( $id ) 
                    or die "Bad PK '$id' for $module $source_name\n";

                if ( $test_sub && !$test_sub->( $rec ) ) {
                    $num_skipped++;
                    next ID;
                }

                my $text = @columns 
                    ? join $SPACE, 
                        grep { $_ ne 'NULL' }
                        map  { defined $_ ? $_ : () } 
                        map  { $rec->$_() } 
                        @columns
                    : $EMPTY_STR
                ;

                my @ontologies;

                OTHER_TABLE:
                for my $other ( @index_also ) {
                    my @other_columns = @{ $other->{'columns'} || [] } or next;
                    my @methods       = split( /\./, $other->{'table_name'} );
                    my $other_obj     = $rec;

                    # drill into "qtl.qtl_trait.qtl_trait_category"
                    while ( my $method = shift @methods ) {
                        last unless $other_obj;
                        ($other_obj) = $other_obj->$method() or last;
                    }

                    if ( $other_obj ) {
                        $text .= join( $SPACE, 
                            $EMPTY_STR,
                            grep { $_ ne 'NULL' }
                            map  { defined $_ ? $_ : () }
                            map  { $other_obj->$_() }
                            @other_columns
                        );
                    }
                }

                SQL:
                for my $sql ( @additional_sql ) {
                    my @args;
                    if ( $sql =~ /\?/ ) {
                        push @args, $id;
                    }
                    elsif ( $sql =~ /\[(\w+)\]/ ) {
                        my $fld = $1;
                        if ( my $val = $rec->$fld() ) {
                            $sql =~ s/\[.*?\]/?/;
                            push @args, $val;
                        }
                        else {
                            next SQL;
                        }
                    }

                    my $sth = $dbh->prepare( $sql );
                    $sth->execute( @args );

                    while ( my $d = $sth->fetchrow_hashref ) {
                        my @flds = keys %$d or next;

                        if ( my $s = 
                            join( $SPACE, 
                                uniq( map { defined $_ ? $_ : () } values %$d ) 
                            ) 
                        ) {
                            $text .= $SPACE . $s;
                        }

                        if ( my $tax_id = $d->{'ncbi_taxonomy_id'} ) {
                            push @ontologies, $odb->search_xref( $tax_id );
                        }
                    }
                }

                my $hs = HTML::Strip->new;
                $text = $hs->parse( $text );
                $hs->eof;

                $text =~ s/^\s+//g; # trim
                $text =~ s/, / /g;  # kill commas

                #
                # This takes care of transcript names, e.g., "LOC_Os01g01410.2"
                #
                $text =~ s/\b(([\w_-]+)\.\d+)\b/$1 $2/g;

                $text = join( $SPACE, uniq( split( /\s+/, $text ) ) );

                next if !$text;

                my ( @ontology_accs, @taxonomy );
                if ( $module ne 'ontology' ) {
                    my %tmp;
                    while ( $text =~ /(($ont_pref):\d+)/ig ) {
                        my $acc = $1;
                        if ( $ont_acc{ lc $acc } ) {
                            $tmp{ $acc }++;
                        }
                    }

                    @ontology_accs = keys %tmp;
                    @taxonomy      = grep { /^gr_tax:/i } @ontologies;
                }

                my $species_name = '';
                if ( 
                    $module =~ /^(ensembl|variation|pathway|reactome)_(\w+)/ 
                ) {
                    $species_name = ucfirst lc $2;
                }
                elsif ( @taxonomy == 1 ) {
                    ( $species_name = ucfirst lc $taxonomy[0] ) =~ s/ /_/g;
                }

                my $title = '';
                if ( my %list_columns = %{ $sconf->{'list_columns'} || {} } ) {
                    while ( my ($list_type, $list_def) = each %list_columns ) {
                        my ($list_module, $list_table) 
                            = split /\./, $list_type;

                        my @title_vals;
                        next unless $module =~ /$list_module/ 
                            && $table eq $list_table;

                        if ( $list_def =~ /^TT:(.*)/ ) {
                            my $tmpl = $1;
                            my $tt   = Template->new;
                            ( my $display_species = $species_name ) =~ s/_/ /g;
                            $tt->process( 
                                \$tmpl, 
                                { 
                                    object      => $rec, 
                                    module      => $module,
                                    table       => $table,
                                    object_type => $object_type,
                                    species     => $display_species,
                                }, 
                                \$title 
                            ) or $title = $tt->error;
                        }
                        else {
                            my $format = ''; 
                            if ( $list_def =~ s/ [(] (.*) [)]$ //xms ) {
                                $format = $1;
                            }

                            my $method = '';
                            for my $list_fld ( split /\s*,\s*/, $list_def ) {
                                my $obj     = $rec;
                                my @methods = split /\./, $list_fld;
                                my $val     = '';
                                while ( my $method = shift @methods ) {
                                    if ( @methods ) {
                                        $obj = $obj->$method() or last;
                                    }
                                    else {
                                        $val = $obj->$method || '';
                                        last;
                                    }
                                }

                                push @title_vals, $val || '';
                            }

                            if ( $format ) {
                                $title = sprintf $format, @title_vals;
                            }
                            else {
                                $title = join $SPACE, @title_vals;
                            }
                        }

                        last;
                    }
                }

                $title ||= substr $text, 0, 50;

                my $doc = {
                    id       => join( '/', $module, $table, $id ),
                    species  => lc $species_name,
                    module   => $module,
                    object   => $object_type,
                    title    => $title,
                    content  => lc $text,
                    taxonomy => \@taxonomy,
                    ontology => [ grep { !/^gr_tax/i } @ontology_accs ],
                };

                push @batch, $doc;
                if ( scalar @batch == $batch_size ) {
                    $indexer->add( @batch );
                    @batch = ();
                }
            }

            $indexer->add( \@batch );
            $num_records += $i;

            printf "%-70s\n\n", sprintf(
                'Loaded %s record%s in %s',
                commify($i),
                $num_records == 1 ? '': 's',
                $timer->(),
            );
        }

        $indexer->commit;
        $num_modules++;
    }

    return { 
        num_modules => $num_modules,
        num_tables  => $num_tables, 
        num_records => $num_records,
        num_skipped => $num_skipped,
        time        => $total_timer->(),
    };
}

# ----------------------------------------------------
sub sql_to_index {

=pod

=head2 sql_to_index

  my %sql_by_table = $sdb->sql_to_index( $module );

  for my $table ( keys %sql_by_table ) {
      for my $sql ( @{ $sql_by_table{ $table } } ) {
        ...
      }
  }

Returns a hash(ref) of SQL statements to index for a given module.
Keys of the hash will be table names.

=cut

    my $self         = shift;
    my $module       = shift or return;
    my $sconf        = $self->config->get('search');
    my %sql_to_index = %{ $sconf->{'sql_to_index'} || {} } or return;

    my %sql_by_table;
    for my $section ( keys %sql_to_index ) {
        my ( $mod_name, $table_name ) = split /\./, $section;

        next if $module !~ /$mod_name/;

        my $text = $sql_to_index{ $section };

        push @{ $sql_by_table{ $table_name } }, 
            map { s/^\s+|\s+$//g; $_ || () }
            split /;/, $text;
    }

    return wantarray ? %sql_by_table : \%sql_by_table;
}

# ----------------------------------------------------
sub tables_to_index {

=pod

=head2 tables_to_index

  my %tables = $sdb->tables_to_index( $module );

Returns a hash(ref) of the tables to index for a given module.

=cut


    my $self            = shift;
    my $module          = shift or return;
    my $sconf           = $self->config->get('search');
    my %tables_to_index = %{ $sconf->{'tables_to_index'} || {} } or return;
    
    my %return;
    for my $mod_name ( keys %tables_to_index ) {
        next if $module !~ /$mod_name/;

        my $tables = $tables_to_index{ $mod_name };

        while ( my ( $index_table, $def ) = each %$tables ) {
            my $object_type = $index_table;
            if ( $index_table =~ /([^#]+) [#] ([^#]+)/xms ) {
                $index_table = $1;
                $object_type = $2;
            }

            if ( $def =~ /
                (        # capture a
                \[       # left square
                (.*?)    # list (optionally null) of fields
                \]       # right square
                )?       # optional
                (?:      # non-capturing
                \+       # literal plus sign
                (.+)     # list of other tables
                )?       # end optional non-capturing
                /xms
            ) {
                my $index_field_group = $1 || $EMPTY_STR;
                my $index_fields      = $2 || $EMPTY_STR;
                my $other_tables      = $3 || $EMPTY_STR;

                my @index_fields;
                if ( $index_field_group eq $EMPTY_STR ) {
                    @index_fields = ( $ALL );
                }
                else {
                    @index_fields = ( split /,/, $index_fields );
                }

                $return{ $index_table } = {
                    fields      => \@index_fields,
                    object_type => $object_type,
                };

                for my $table ( split /[+]/, $other_tables ) {
                    if ( $table =~ /
                        ([\w.]+) # table name
                        (     # start capture
                        \[    # left square
                        (.*?) # list (optionally null) of fields
                        \]    # right square
                        )?    # optional
                        /xms
                    ) {
                        my $other_table_name        = $1 || $EMPTY_STR;
                        my $other_table_field_group = $2 || $EMPTY_STR;
                        my $other_table_fields      = $3 || $EMPTY_STR;

                        my @other_index_fields;
                        if ( $other_table_fields eq $EMPTY_STR ) {
                            @other_index_fields = ( $ALL );
                        }
                        else {
                            @other_index_fields 
                                = ( split /,/, $other_table_fields );
                        }

                        push @{ 
                            $return{ $index_table }{'other_tables'}
                        }, 
                        { 
                            table_name => $other_table_name, 
                            fields     => \@other_index_fields,
                        }
                    }
                }
            }
            else {
                $return{ $index_table } = { fields => $ALL };
            }
        }
    }

    return wantarray ? %return : \%return;;
}

# ----------------------------------------------------
sub search {
#
# Search can be by "id" or "query"
#
    my ( $self, %args ) = @_;

    my $params       = $args{'params'}    || {};
    my $id           = $args{'id'}        || $params->{'id'}        || '';
    my $query        = $args{'query'}     || $params->{'query'}     || '';
    my $page_size    = $args{'page_size'} || $params->{'page_size'} || 10;
    my $page_num     = $args{'page_num'}  || $params->{'page_num'}  ||  1;
    my $do_highlight = $args{'hl'}        // 1;
    my $do_facet     = $args{'facet'}     // 1;
    my $gconfig      = $self->config;
    my $odb          = Grm::Ontology->new;
    my $timer        = timer_calc();
    my $results      = {};

    return {} unless $id or $query;

    my $url_base = sprintf( 
        '/select?q=%s&wt=json', 
        $query ? 'text:%s' : "id:$id" 
    );

    #
    # Parse out the request, figure out the "fq" facet queries
    # Create a query string to tack onto the maing "query"
    #
    my $get_url_params = "&rows=$page_size";
    if ( my $fl = $args{'fl'} ) {
        $get_url_params .= "&fl=$fl";
    }

    if ( $do_highlight ) {
        $get_url_params .= 
          '&hl=true&hl.fl=content&hl.simple.pre=<em>&hl.simple.post=</em>';
    }

    if ( $do_facet ) {
        $get_url_params .= '&facet=true&facet.mincount=1' 
            . '&facet.field=species' 
            . '&facet.field=ontology' 
            . '&facet.field=object';
    }

    my %fq;
    while ( my ( $key, $value ) = each %$params ) {
        next if $key eq 'query' || $key eq 'id';
        my @values = ref $value eq 'ARRAY' ? @$value : ( $value );
        if ( $key eq 'fq' ) {
            FQ_VAL:
            for my $fq_val ( @values ) {
                my ( $facet_name, $facet_val ) 
                    = split( /:/, $fq_val, 2 );

                if ( defined $facet_val && $facet_val =~ /\w+/ ) {
                    if ( $facet_name eq 'species' ) {
                        if ( lc $facet_val eq 'multi' ) {
                            next FQ_VAL;
                        }

                        $facet_val = lc $facet_val;
                        $facet_val =~ s/\s+/_/g;
                    }

                    push @{ $fq{ $facet_name } }, $facet_val;
                }
            }
        }
        else {
            for my $v ( @values ) {
                $get_url_params .= sprintf( '&%s=%s', $key, $v );
            }
        }
    }

    while ( my ( $facet_name, $values ) = each %fq ) {
        for my $val ( @$values ) {
            $get_url_params .= sprintf( 
                '&fq=%s:%%22%s%%22', 
                $facet_name, 
                trim(unquote(url_unescape($val)))
            );
        }
    }

    if ( $page_num > 1 ) {
        $get_url_params .= '&start=' . ($page_num - 1) * $page_size;
    }

    #
    # See if query looks like "chr:start-stop," e.g., 
    # "11 : 14375589-14373565"
    # or
    # "12:17360493...17361111"
    #
    if ( 
        $query =~ /^
            ([\w.-]+)        # seq_region name (chr, scaffold)
            \s*              # maybe space
            :                # literal colon
            \s*              # maybe space
            ([\d,]+)         # start
            \s*              # maybe space
            (?:\.{2,3}|[-])  # either ellipses (2 or 3) or dash
            \s*              # maybe space
            ([\d,]+)         # stop
        $/xms 
    ) {
        my ( $chr, $start, $stop ) = ( $1, $2, $3 );
        my $url_query  = $chr . '%3A' . $start . '-' . $stop;
        my %fq_species = map { lc $_, 1 } @{ $fq{'species'} || [] };
        my @suggestions = ();

        SPECIES:
        for my $ens_species (
            grep { /^ensembl_/ } $gconfig->get('modules')
        ) {
            ( my $species = $ens_species ) =~ s/^ensembl_//;
            if ( %fq_species && !$fq_species{ $species } ) {
                next SPECIES;
            }

            my $db = Grm::DB->new( $ens_species );
            my ($count) = $db->dbh->selectrow_array(
                q[
                    select count(*) 
                    from   seq_region 
                    where  name=?
                    and    length>?
                ],
                {},
                ( $chr, $stop )
            );

            next unless $count > 0;

            my $url_species = $db->alias || $species;
            ( my $display = $species ) =~ s/_/ /g;
            push @suggestions, {
                url => sprintf(
                    'http://ensembl.gramene.org/%s/'.
                    'Location/View?r=%s',
                    ucfirst( $url_species ),
                    $url_query,
                ),
                title => sprintf( 
                    'Ensembl %s &quot;%s&quot;</a>',
                    ucfirst( $display ),
                    $query,
                )
            };
        }

        $results->{'suggestions'} = \@suggestions;
    }
    #
    # Looks legit, so go search Solr
    #
    else {
        if ( ref $page_num eq 'ARRAY' ) {
            $page_num = max( $page_num );
        }

        my $sconfig  = $gconfig->get('search');
        my $solr_url = $sconfig->{'solr'}{'url'} or die 'No Solr URL';
        my $ua       = LWP::UserAgent->new;

        $ua->agent('GrmSearch/0.1');

        my @urls;
        if ( $query ) {
            for my $qry ( iterative_search_values( $query ) ) {
                # quote the value if it has a colon as this (e.g., "GO:0001132")
                # has special meaning to Solr (e.g., "species:Zea_mays")
                $qry =~ s/\b(.*[:].*)/%22$1%22/g; 
                $qry =~ s/ /+/g;

                push @urls, 
                    sprintf( $solr_url . $url_base, $qry ) . $get_url_params;
            }
        }
        else {
            @urls = ( $solr_url . $url_base . $get_url_params );
        }

        for my $url ( @urls ) {
            my $res = $ua->request( HTTP::Request->new( GET => $url ) );

            if ( $res->is_success ) {
                $results = decode_json($res->content);
            }
            else {
                $results = { 
                    code  => $res->code,
                    error => $res->message,
                };
            }

            last if $results->{'response'}{'numFound'} > 0;
        }

        $results->{'time'} = $timer->( format => 'seconds' );
    }

    return $results;
}

1;

__END__

=pod

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2013 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.
