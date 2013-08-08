package Grm::Search;

=head1 NAME

Grm::Search - search-related code for Gramene

=head1 SYNOPSIS

  use Grm::Search;

  my $sdb = Grm::Search->new(
      config     => ..., 
      base_dir   => ...,
      index_path => ...,
      page_size  => ...,
  );

=head1 DESCRIPTION

All the stuff for Gramene's Lucy-based searching.

=head1 METHODS

=head2 config

Returns or sets the Grm::Config object

=head2 base_dir

Returns or sets the root of the Gramene installation

=head2 index_path

Returns or sets the relative (from base_dir) or absolute path to 
search index

=head2 page_size

Returns or sets the integer value for the size of the pages of results.

=head2 schema

Returns the Lucy schema object.

=head2 indexer

Should return the Lucy indexer object.

=cut

# ----------------------------------------------------

use strict;
use warnings;
use namespace::autoclean;

use DateTime;
use Moose;
use Carp;
use CGI;
use List::Util qw( max min );
use POSIX qw( ceil );
use Encode qw( decode );
use File::Find::Rule;
use File::Spec::Functions qw( catdir );
use File::Path;
use Grm::Config;
use Grm::Maps;
use Grm::Utils qw( timer_calc commify extract_ontology camel_case );
use Grm::Search::Indexer::MySQL;
use List::MoreUtils qw( uniq );
use Lucy::Search::IndexSearcher;
use Lucy::Highlight::Highlighter;
use Lucy::Search::QueryParser;
use Lucy::Search::TermQuery;
use Lucy::Search::ANDQuery;
use LucyX::Search::WildcardQuery;
use Time::HiRes qw( gettimeofday tv_interval );
use Readonly;

Readonly my $ALL         => '[[all]]';
Readonly my $COMMA_SPACE => q{, };
Readonly my $EMPTY_STR   => q{};
Readonly my $SPACE       => q{ };

has config     => (
    is         => 'rw',
    isa        => 'Grm::Config',
);

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
    my $self       = shift;
    my $args       = shift || {};
    my $conf       = $args->{'config'} || Grm::Config->new;
    my $sconf      = $conf->get('search');
    my $index_path = $args->{'config'} || $sconf->{'index_path'};
    my $base_dir   = $args->{'base_dir'} || $conf->get('base_dir');

    if ( $index_path !~ m{^/} ) {
        $index_path = catdir( $base_dir, $index_path );
    }    

    if ( !-d $index_path ) {
        mkpath $index_path;
    }

    $self->index_path( $index_path );

    $self->config( $conf );

    $self->page_size( $args->{'page_size'} || $sconf->{'page_size'} || 10 );
}

# ----------------------------------------------------
sub _build_schema {
    my $self          = shift;
    my $schema        = Lucy::Plan::Schema->new;
    my $polyanalyzer  = Lucy::Analysis::PolyAnalyzer->new( language => 'en' );
    my $non_indexed   = Lucy::Plan::StringType->new( indexed => 0 );
    my $fulltext      = Lucy::Plan::FullTextType->new(
        analyzer      => $polyanalyzer,
        highlightable => 1,
        sortable      => 1,
    );

    $schema->spec_field( name => 'url',      type => $non_indexed );
    $schema->spec_field( name => 'title',    type => $non_indexed );
    $schema->spec_field( name => 'category', type => $fulltext    );
    $schema->spec_field( name => 'taxonomy', type => $fulltext    );
    $schema->spec_field( name => 'ontology', type => $fulltext    );
    $schema->spec_field( name => 'content',  type => $fulltext    );

    return $schema;
}

# ----------------------------------------------------
sub _build_indexer {
    my $self   = shift;
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

    my $self    = shift;
    my %args    = ref $_[0] eq 'HASH' 
                  ? %{ $_[0] } : scalar @_ == 1 ? ( module => $_[0] )
                  : @_;
    my @modules = ref $args{'module'} eq 'ARRAY' 
                  ? @{ $args{'module'} }
                  : split( /\s*,\s*/, $args{'module'} );
    my $verbose = defined $args{'verbose'} ? $args{'verbose'} : 1;
    my $db_type = $args{'db_type'} || 'mysql';
    my $resume  = $args{'resume'}  ||       0;
    my $sconf   = $self->config->get('search');
    my %stats;

    my $total_timer = timer_calc();
    my ( $num_tables, $num_records ) = ( 0, 0 );
    for my $module ( @modules ) {
        my %tables_to_index  = $self->tables_to_index( $module );
        my %sql_to_index     = $self->sql_to_index( $module );
        my $extract_ontology = $module ne 'ontology';

        my $indexer;
        if ( $db_type eq 'lucy' ) {
            my $lucy_schema      = $self->schema;
            my $module_index     = catdir( $self->index_path, $module );

            # Create an Indexer object.
            $indexer = Lucy::Index::Indexer->new(
                index    => $module_index,
                schema   => $lucy_schema,
                create   => 1,
                truncate => 1,
            ) or die "No indexer\n";
        }
        else {
            $indexer = Grm::Search::Indexer::MySQL->new(
                module => $module
            );

            if ( !$resume ) {
                $indexer->truncate;
            }
        }

        my $odb    = Grm::Ontology->new;
        my $db     = Grm::DB->new( $module );
        my $dbh    = $db->dbh;
        my $schema = $db->dbic;

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

            my @id_fields = $source->primary_columns;

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
                my $other_table  = $other->{'table_name'};

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

            if ( $verbose ) {
                printf "\rProcessing %s record%s in '%s.%s'\n",
                    commify($count),
                    $count == 1 ? '' : 's',
                    $module,
                    $table;
            }

            my $ids = $dbh->selectcol_arrayref("select $id_field from $table");

            my %done;
            if ( $resume ) {
                %done = map { $_, 1 } @{
                    $indexer->dbh->selectcol_arrayref('select url from search')
                };
            }

            $num_tables++;

            $num_records = 0;

            ID:
            for my $id ( @$ids ) {
                $num_records++;

                if ( $verbose ) {
                    printf "%-70s\r", sprintf( "%3s%%: %s", 
                        int(100 * ( $num_records / $count )),
                        commify($num_records), 
                    );
                }

                if ( $resume ) {
                    my $url = join '/', $module, $table, $id;

                    next ID if $done{ $url };
                }

                my $rec = $result->find( $id ) 
                    or die "Bad PK '$id' for $module $source_name\n";

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
                    my $other_table   = $other->{'table_name'};
                    my @other_columns = @{ $other->{'columns'} || [] } or next;

                    for my $other_obj ( 
                        $rec->search_related($other_table)->all
                    ) {
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

                $text = lc $text;
                $text =~ s/^\s+|\s+$//g;       # trim
                $text =~ s/, / /g;             # kill commas
                $text =~ /\A(.+?)^\s+(.*)/ms ; # not sure, stolen
                $text = join( $SPACE, uniq( split( /\s+/, $text ) ) );

                next if !$text;

                my $title = '';
                if ( my %list_columns = %{ $sconf->{'list_columns'} || {} } ) {
                    while ( my ($list_type, $list_def) = each %list_columns ) {
                        my ($list_module, $list_table) 
                            = split /\./, $list_type;

                        my @title_vals;
                        if ( 
                            $module =~ /$list_module/ && $table eq $list_table
                        ) {
                            for my $list_fld ( split /\s*,\s*/, $list_def ) {
                                if ( $rec->can( $list_fld ) ) {
                                    if ( my $val = $rec->$list_fld() ) {
                                        push @title_vals, $val;
                                    }
                                }
                            }
                        }

                        $title = join $SPACE, @title_vals;
                    }
                }

                $title ||= substr $text, 0, 50;

                push @ontologies, extract_ontology( $text );
                my @ontology_accs 
                    = map { $_->term_accession } uniq( @ontologies );

                my $doc = {
                    url      => join( '/', $module, $table, $id ),
                    title    => $title,
                    content  => $text,
                    taxonomy => 
                        join( $SPACE, grep {  /^GR_tax/ } @ontology_accs ),
                    ontology => 
                        join( $SPACE, grep { !/^GR_tax/ } @ontology_accs ),
                };

                $indexer->add_doc( $doc );
            }

            my $dt = DateTime->now;
            $indexer->add_meta(
                source_db    => $db->real_name,
                last_indexed => $dt->ymd,
                indexed_by   => (getpwuid($<))[0],
            );

            if ( $verbose ) {
                printf "%-70s\n\n", sprintf(
                    'Loaded %s record%s in %s',
                    commify($num_records),
                    $num_records == 1 ? '': 's',
                    $timer->(),
                );
            }
        }

        $indexer->commit;
    }

    return { 
        num_tables  => $num_tables, 
        num_records => $num_records,
        time        => $total_timer->(),
    };
}

# ----------------------------------------------------
sub connect_mysql_search_db {
    my ( $self, $db_name ) = @_;
    my $config = $self->config->get('search');

    if ( $db_name !~ /^grm_search_/ ) {
        $db_name = 'grm_search_' . $db_name;
    }

    my $dsn = sprintf('dbi:mysql:host=%s;database=%s',
        $config->{'database'}{'host'},
        $db_name
    );

    my $dbh = DBI->connect(
        $dsn,
        $config->{'database'}{'user'},
        $config->{'database'}{'password'},
        { RaiseError => 1 }
    );

    return $dbh;
}

# ----------------------------------------------------
sub search_mysql {

=pod

=head2 search_mysql

  my $results = $sdb->search_mysql('waxy');

  my $results = $sdb->search( 
      query     => 'waxy', # required
      category  => 'genomes',
      db        => 'maps',
      limit     => 50,
      nopage    => 1,
      page_size => 50,
      offset    => 100,
  );

Performs a search.  Only "query" is required, and if only one argument 
is present, it is assumed to be "query."  

Options include:

=over 4

=item offset

[Integer] How far into the result set to go

=item category

[String] Gramene search category

=item limit

[Integer] Number of results

=item nopage

[Boolean] Don't bother paging the results, just return everything

=item page_size

[Integer] Size of the pages

=back

=cut

    my $self       = shift;
    my $timer      = timer_calc();
    my %args       = ref $_[0] eq 'HASH' 
                       ? %{ $_[0] } 
                       : scalar @_ == 1 
                         ? ( query => $_[0] ) : @_;
    my $query      = $args{'query'}    or return;
    my $qry_db     = $args{'db'}       || '';
    my $taxonomy   = $args{'taxonomy'} || '';
    my $offset     = $args{'offset'}   ||  0;
    my $category   = $args{'category'} || '';
    my $limit      = $args{'limit'}    ||  0;
    my $page_size  = $args{'nopage'} 
                   ? undef 
                   : $args{'page_size'} || $self->page_size;

    my $hit_count  = 0;
    my $debug      = sub { $args{'debug'} && print STDERR @_, "\n" };

    #
    # Check if the query looks like an ontology accession
    #
    my $Term;
    if ( $query =~ /^[A-Za-z_]+ : \d+$/xms ) {
        my $ont_db   = Grm::Ontology->new;
        my $schema   = $ont_db->db->schema;
        my @term_ids = $ont_db->search( query => $query );
        if ( scalar @term_ids == 1 ) {
            my $term_id = shift @term_ids;
            $Term = $schema->resultset('Term')->find($term_id);
        }
    }

    my @dbs = $self->search_dbs;

    if ( $qry_db ) {
        @dbs = grep { /$qry_db/i } @dbs;
    }

    my @hits;

    DB:
    for my $db_name ( @dbs ) {
        my ( $grm, $search, @rest ) = split /_/, $db_name;
        my $this_category = $rest[0];

        if ( $category ) {
            next DB unless lc $this_category eq lc $category;
        }

        my $dbh = $self->connect_mysql_search_db( $db_name );

        my ( $sql, @args );

        if ( $db_name eq 'grm_search_ontology' && $Term ) {
            $sql = qq[
                select url, title, taxonomy, ontology, content,
                       content as excerpt, '1' as score,
                       'ontology' as category
                from   search
                where  url=?
            ];

            @args = ( sprintf 'ontology/term/%s', $Term->id );
        }
        else {
            $sql = sprintf(
                qq[
                    select url, title, taxonomy, ontology, content,
                           content as excerpt,
                           match(content) against (%s) as score,
                           '$this_category' as category
                    from   search
                    where
                    match(content) against (%s in boolean mode)
                ],
                $dbh->quote($query),
                $dbh->quote('%' . $query . '%'),
            );

            if ( $Term ) {
                $sql .= sprintf( 
                    " and ontology like '%%%s%%' ", $Term->term_accession
                );
            }

            if ( $taxonomy ) {
                my @tax = ref $taxonomy eq 'ARRAY' ? @$taxonomy : ( $taxonomy );

                if ( my @valid = grep { /^GR_tax:\d+/ } @tax ) {
                    if ( scalar @valid == 1 ) {
                        $sql .= ' and taxonomy=? ';
                        push @args, shift @valid;
                    }
                    else {
                        $sql .= sprintf(
                            ' and taxonomy in (%s) ',
                            join( ', ', map { $dbh->quote($_) } @valid )
                        );
                    }
                }
            }
        }

        $sql    .= 'order by score desc';
        my $hits = $dbh->selectall_arrayref( $sql, { Columns => {} }, @args );
        my $num  = scalar @$hits;

        $debug->(sprintf('Found %s for "%s" in %s', $num, $query, $db_name));

        if ( $num ) {
            $hit_count += $num;
            push @hits, @$hits;
        }
    }

    if ( !$category || ( $category && $category =~ /ensembl/ ) ) {
        my @ens_hits = $self->_search_ensembl( $query, $qry_db, $debug );
        push @hits, @ens_hits;
        $hit_count += scalar @ens_hits;
    }

    if ( !$category || ( $category && $category =~ /maps/ ) ) {
        my @maps_hits = $self->_search_maps( $query, $qry_db, $debug );
        push @hits, @maps_hits;
        $hit_count += scalar @maps_hits;
    }

    return { 
        num_hits => $hit_count,
        data     => \@hits, 
        time     => $timer->(),
    };
}

# ----------------------------------------------------
sub _search_ensembl {
    my ( $self, $query, $qry_db, $debug ) = @_;
    $query =~ s/\*/%/g;
    my @ensembl_modules  
        = grep { /^(variation|ensembl)_/ } $self->config->get('modules');

    my @hits;
    ENS_MODULE:
    for my $ens_module ( @ensembl_modules ) {
        next if $qry_db && $qry_db !~ /$ens_module/;

        my $db = Grm::DB->new( $ens_module );
        my $is_variation = ( $ens_module =~ /variation/ );

        eval {
            my $dba_class = sprintf( 
                'Bio::EnsEMBL::%sDBSQL::DBAdaptor',
                $is_variation ? 'Variation::' : '',
            );

            my $dba = $dba_class->new(
                -user   => $db->user,
                -pass   => $db->password,
                -dbname => $db->real_name,
                -host   => $db->host,
                -driver => $db->dbd,
            ); 

            my @tmp;

            if ( $ens_module =~ /variation/ ) {
                if ( my $var_adaptor = $dba->get_adaptor('Variation') ) {
                    my $db = $var_adaptor->db->dbc->db_handle;
                    push @tmp, @{ $db->selectall_arrayref(
                        qq[
                            select concat_ws('/', 
                                    '$ens_module', 'variation', variation_id 
                                   ) as url,
                                   name as title,
                                   name as content,
                                   name as excerpt,
                                   'ensembl' as category,
                                   '' as ontology
                            from   variation 
                            where  name=?
                        ],
                        { Columns => {} },
                        $query,
                    ) };
                }
            }
            else {
                if ( my $feat_adaptor = $dba->get_adaptor('DnaAlignFeature') ) {
                    my @features = @{ 
                        $feat_adaptor->fetch_all_by_hit_name( $query ) 
                    };

                    my %seen;
                    for my $f ( @features ) {
                        next if $seen{ $f->hseqname }++;

                        push @tmp, {
                            url => join('/', 
                                $ens_module, 'dna_align_feature', $f->dbID
                            ),
                            title    => $f->hseqname,
                            category => 'ensembl',
                            ontology => '',
                            content  => join( $SPACE, 
                                $f->hseqname,
                                $f->analysis->display_label 
                                    || $f->analysis->logic_name,
                                $f->feature_Slice->name
                            ),
                        };
                    }
                }

                if ( my $marker_adaptor = $dba->get_adaptor('Marker') ) {
                    my @markers = @{ 
                        $marker_adaptor->fetch_all_by_synonym( $query ) 
                    };

                    for my $m ( @markers ) {
                        my $content = join( $SPACE,
                            map { $_->name() } 
                            @{ $m->get_all_MarkerSynonyms }
                        );

                        push @tmp, {
                            url => join('/', $ens_module, 'marker', $m->dbID),
                            title    => $m->dbID,
                            category => 'ensembl',
                            ontology => '',
                            content  => join( $SPACE,
                                map { $_->name() } 
                                @{ $m->get_all_MarkerSynonyms }
                            ),
                        };
                    }
                }
            }

            $debug->(sprintf('Found %s in %s', scalar @tmp, $ens_module));
            push @hits, @tmp;
        };
    }

    return @hits;
}

# ----------------------------------------------------
sub _search_maps {
    my ( $self, $query, $qry_db, $debug ) = @_;

    return if $qry_db && $qry_db !~ /maps/;

    my $maps = Grm::Maps->new;
    my @hits;

    for my $f ( $maps->feature_search( feature_name => $query ) ) {
        my $title = join( ' ',
            map { $f->{ $_ } } qw[ species feature_type feature_name ]
        );

        push @hits, {
            url      => join('/', 'maps', 'feature', $f->{'feature_id'}),
            title    => $title,
            content  => $title,
            taxonomy => $f->{'species'},
            category => 'maps',
        };
    }

    $debug->(sprintf('Found %s features in maps', scalar @hits));

    return @hits;
}

# ----------------------------------------------------
sub search_dbs {

=pod

=head2 search_dbs

  my @dbs = $sdb->search_dbs;

=cut

    my $self   = shift;
    my $config = $self->config->get('search');

    return @{ $config->{'search_dbs'} };
}

# ----------------------------------------------------
sub search {

=pod

=head2 search

  my $results = $sdb->search('waxy');

  my $results = $sdb->search( 
      query     => 'waxy', # required
      offset    => 100,
      category  => 'genomes',
      limit     => 50,
      nopage    => 1,
      page_size => 50,
  );

Performs a search.  Only "query" is required, and if only one argument 
is present, it is assumed to be "query."  

Options include:

=over 4

=item offset

[Integer] How far into the result set to go

=item category

[String] Gramene search category

=item limit

[Integer] Number of results

=item nopage

[Boolean] Don't bother paging the results, just return everything

=item page_size

[Integer] Size of the pages

=back

=cut

    my $self       = shift;
    my $timer      = timer_calc();
    my %args       = ref $_[0] eq 'HASH' 
                       ? %{ $_[0] } 
                       : scalar @_ == 1 
                         ? ( query => $_[0] ) : @_;
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

        my @flds = qw[ url title category content taxonomy ontology ];

        # Create result list.
        while ( my $hit = $hits->next ) {
            push @hits, { 
                score        => $hit->get_score,
                pretty_score => sprintf( "%0.3f", $hit->get_score ),
                excerpt      => $highlighter->create_excerpt($hit),
                ( map { $_ => $hit->{ $_ } } @flds )
            };
        }
    }

    return { 
        num_hits => scalar @hits,
        data     => \@hits, 
        time     => $timer->(),
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

        for my $table ( split /;/, $tables ) {
            if ( $table =~ /
                (\w+)  # table name
                (      # capture a
                \[     # left square
                (.*?)  # list (optionally null) of fields
                \]     # right square
                )?     # optional
                (?:    # non-capturing
                \+     # literal plus sign
                (.+)   # list of other tables
                )?     # end optional non-capturing
                /xms
            ) {
                my $index_table       = $1 || $EMPTY_STR;
                my $index_field_group = $2 || $EMPTY_STR;
                my $index_fields      = $3 || $EMPTY_STR;
                my $other_tables      = $4 || $EMPTY_STR;

                my @index_fields;
                if ( $index_field_group eq $EMPTY_STR ) {
                    @index_fields = ( $ALL );
                }
                else {
                    @index_fields = ( split /:/, $index_fields );
                }

                $return{ $index_table } = {
                    fields => \@index_fields
                };

                for my $table ( split /,/, $other_tables ) {
                    if ( $table =~ /
                        (\w+) # table name
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
                                = ( split /:/, $other_table_fields );
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
                $return{ $table } = { fields => $ALL };
            }
        }
    }

    return wantarray ? %return : \%return;;
}

1;

__END__

=pod

=head1 SEE ALSO

Apache::Lucy.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

