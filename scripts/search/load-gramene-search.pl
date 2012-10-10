#!/usr/local/bin/perl

# vim: tw=78: sw=4: ts=4: et: 

# $Id: load-gramene-search.pl 16136 2012-04-26 19:13:07Z kclark $

use strict;
use warnings;
use DBI;
use Data::Dumper;
use English qw( -no_match_vars );
use File::Basename;
use File::Extract::PDF;
use File::Extract::Result;
use CAM::PDF;
use File::Find::Rule;
use File::Spec::Functions;
use Getopt::Long;
use Gramene::CDBI::GrameneSearch;
use Gramene::CDBI::Ontology;
use Gramene::Ontology::OntologyDB;
use List::MoreUtils qw( uniq );
use HTML::HeadParser;
use HTML::Strip;
use IO::Prompt;
use PDF::API2;
use Perl6::Slurp;
use Pod::Usage;
use Readonly;

$| = 1;

use Gramene::Config;
use Gramene::DB;
use Gramene::Utils qw( commify table_name_to_gramene_cdbi_class );

delete @ENV{qw(IFS CDPATH ENV BASH_ENV)};
$ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin';

Readonly my $ALL            => '[[all]]';
Readonly my $ANTIWORD       => '/usr/local/bin/antiword';
Readonly my $COMMA_SPACE    => q{, };
Readonly my $DBL_COLON      => q{::};
Readonly my $EMPTY_STR      => q{};
Readonly my $GRAMENE_SEARCH => 'gramene_search';
Readonly my $NL             => qq{\n};
Readonly my $SLASH          => q{/};
Readonly my $SPACE          => q{ };

my $modules       = $EMPTY_STR;
my $redo_tables   = $EMPTY_STR;
my $continue_load = 0;
my $list_modules  = 0;
my $list_db_name  = 0;
my $no_prompt     = 0;
my ( $help, $man_page );
GetOptions(
    'l|list'          => \$list_modules,
    'd|with-db-name'  => \$list_db_name,
    'm|modules:s'     => \$modules,
    'r|redo-tables:s' => \$redo_tables,
    'c|continue'      => \$continue_load,
    'no-prompt'       => \$no_prompt,
    'help'            => \$help,
    'man'             => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my %process      = map { s/^\s+|\s+//g; lc $_, 1 } split /,/, $modules;
my %redo_table   = map { s/^\s+|\s+//g; lc $_, 1 } split /,/, $redo_tables;
my $config       = Gramene::Config->new;
my $modules_conf = $config->get('modules');
my $search_conf  = $config->get( $GRAMENE_SEARCH );
( my $db_name    = $search_conf->{'db_dsn'} ) =~ s/.*://;
my @modules      = ref $modules_conf->{'module'} eq 'ARRAY' 
                   ? @{ $modules_conf->{'module'} } 
                   : ( $modules_conf->{'module'} );
my %valid_module 
    = map { $_, 1 } grep { !/$GRAMENE_SEARCH/ } ( @modules, 'documents' );

if ( %process ) {
    my @bad = grep { !exists $valid_module{ $_ } } keys %process;

    if ( @bad ) {
        my $bad   = join $COMMA_SPACE, sort @bad;
        my $valid = join $COMMA_SPACE, sort @modules;
        die "Bad modules ($bad).\nPlease choose from:\n$valid\n";
    }

    unless ( $no_prompt ) {
        my $ok = prompt -yn, 
            sprintf( "OK to %s %s in '$db_name'? ",
                $continue_load ? 'continue loading' : 'recache',
                %process 
                    ? join($COMMA_SPACE, sort keys %process) 
                    : join($COMMA_SPACE, sort @modules)
            )
        ;

        if ( !$ok ) {
            print "Exiting.\n";
            exit 0;
        } 
    }
}
else {
    eval {
        %process = map { $_, 1 }
            prompt -menu => [ (sort keys %valid_module), 'ALL' ], 
            'Which module?';

        if ( $process{'ALL'} ) {
            %process = %valid_module;
        }
    };

    if ( $@ ) {
        print "No db specified.  Please choose from the following list.\n";
        $list_modules = 1;
    }
}

if ( $list_modules ) {
    my @module_list = sort keys %valid_module;

    if ( $list_db_name ) {
        my @with_db_name;
        for my $module_name ( @module_list ) {
            if ( $module_name ne 'documents' ) {
                my $mconf    =  $config->get( $module_name );
                my $db_name  =  $mconf->{'db_dsn'} 
                                or croak("No db_dsn for $module_name");
                $db_name     =~ s/^dbi:mysql://i;

                if ( $db_name =~ /database=(\w+)/ ) {
                    $db_name = $1;
                }

                $module_name .= " => $db_name";
            }

            push @with_db_name, $module_name;
        }

        @module_list = @with_db_name;
    }

    print join $NL, 
        'Valid modules:', ( map { "  $_" } @module_list ),
        $EMPTY_STR;
    exit 0;
}

my $search_db   = Gramene::DB->new( $GRAMENE_SEARCH );
my $num_modules = 0;
my $num_records = 0;

MODULE:
for my $module ( uniq( @modules ) ) {
    next MODULE if $module eq $GRAMENE_SEARCH;
 
    if ( %process ) {
        next MODULE if !defined $process{ lc $module };
    }

    my ( %index_only, %skip );
    for my $mod_name ( keys %{ $search_conf->{'limit_index'} } ) {
        next if $module !~ /$mod_name/;

        my $search_limit = $search_conf->{'limit_index'}{ $mod_name };

        my ( $directive, $tables ) = split /=/, $search_limit;

        if ( $directive !~ /^(index_only|skip)$/ ) {
            die "Bad directive ($directive) in limit clause ($search_limit).\n";
        }

        for my $table ( split /;/, $tables ) {
            if ( $directive eq 'skip' ) {
                $skip{ $table } = 1;
            }
            else {
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

                    $index_only{ $index_table } = {
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
                                $index_only{ $index_table }{'other_tables'}
                            }, 
                            { 
                                table_name => $other_table_name, 
                                fields     => \@other_index_fields,
                            }
                        }
                    }
                }
                else {
                    $index_only{ $table } = { fields => $ALL };
                }
            }
        }
    }

    my $module_name = join $EMPTY_STR, map { ucfirst } split /_/, lc($module);
    my $CDBI   = join $DBL_COLON, 'Gramene', 'CDBI', $module_name;
    my $CDBIPM = join $SLASH, 'Gramene', 'CDBI', $module_name . '.pm';

    eval { require $CDBIPM };

    if ( my $err = $@ ) {
        print STDERR "Error requiring $CDBIPM: $err\n";
        die $err;
    }

    $num_modules++;

    if ( !$continue_load && !%redo_table ) {
        print "Removing previous data for module '$module'.\n";
        my $ids = $search_db->selectcol_arrayref(
            'select module_search_id from module_search where module_name=?',
            {}, ( $module )
        );

        for my $id ( @$ids ) {
            for my $table ( qw[ module_search_to_ontology module_search ] ) {
                $search_db->do(
                    "delete from $table where module_search_id=?", {}, $id
                );
            }
        }
    }

    TABLE:
    for my $table ( $CDBI->represented_tables ) {
        if ( 
               $skip{ $table } 
            || ( %index_only && !exists $index_only{ $table } )
        ) {
            next TABLE;
        }

        if ( %redo_table ) {
            next TABLE if !$redo_table{ $table };

            if ( !$continue_load ) {
                print "Removing previous data for '$module.$table'.\n";
                $search_db->do(
                    q[
                        delete 
                        from  module_search 
                        where module_name=? 
                        and   table_name=?
                    ], 
                    {},
                    ( $module, $table )
                );
            }
        }

        my $class     = table_name_to_gramene_cdbi_class( $module, $table );
        my @id_fields = $class->columns('Primary');

        if ( scalar @id_fields > 1 ) {
            print STDERR 
                "WARNING: Skipping table '$table'; more than 1 primary key (",
                join($COMMA_SPACE, @id_fields),
                ")\n";
            next TABLE;
        }

        my $id_field = shift @id_fields;

        if ( !$id_field ) {
            print STDERR "No PK in $class\n";
            next TABLE;
        };

        my @columns;
        if ( !%index_only || $index_only{ $table }{'fields'}->[0] eq $ALL ) {
            my @has_a = keys %{ $class->meta_info('has_a') || {} };
            my $skip  = join '|', $id_field, @has_a;
            @columns  = grep { !/($skip)/ } $class->columns('All');
        }
        else {
            @columns  = @{ $index_only{ $table }{'fields'} };
        }

        my @other_tables = @{ $index_only{ $table }{'other_tables'} || [] };

        if ( scalar @columns == 0 && scalar @other_tables == 0 ) {
            print STDERR "No columns or other tables for '$class,' skipping.\n";
            next TABLE;
        }

        my @index_also;
        for my $other ( @other_tables ) {
            my $other_table  = $other->{'table_name'};
            my @other_fields = @{ $other->{'fields'} || [] };
            my $other_class    
                = table_name_to_gramene_cdbi_class( $module, $other_table );
            my $other_id_field = $other_class->columns('Primary');

            if ( !$other_id_field ) {
                print STDERR "No primary key in '$class'!\n";
                next OTHER_TABLE;
            };

            my @other_has_a 
                = keys %{ $other_class->meta_info('has_a') || {} };
            my $other_skip  
                = join '|', $other_id_field, @other_has_a;
            my @other_columns;

            if ( $other_fields[0] eq $ALL ) {
                @other_columns
                  = grep { !/($other_skip)/ } $other_class->columns('All');
            }
            else {
                @other_columns = @other_fields;
            }

            push @index_also, {
                table_name => $other_table,
                class      => $other_class,
                columns    => \@other_columns,
            };
        }

        my $count    
            = $class->db_Main->selectrow_array("select count(*) from $table");

        my @additional_sql;
        for my $section ( keys %{ $search_conf->{'index_sql'} } ) {
            if ( $section =~ /([^.]+)[.]([^.]+)/ ) {
                my ( $m_name, $t_name ) = ( $1, $2 );
                next if $module !~ /$m_name/;
                next if $table  ne $t_name;

                if ( my $sql = $search_conf->{'index_sql'}{ $section } ) {
                    @additional_sql = split /;/, $sql;
                }
            }
        }

        printf "\rProcessing %s record%s in '%s.%s'\n",
            commify($count),
            $count == 1 ? '' : 's',
            $module,
            $table;

        my $module_db = $class->db_Main;
        my $sth       = $module_db->prepare("select $id_field from $table");
        $sth->execute;

        my ( $c, $i ) = ( 1, 1 );
        my $max = 50;
        RECORD:
        while ( my $id = $sth->fetchrow_array ) {
            if ( $i == $max ) {
                $i = 0;
            }
            else {
                print "$c ", ( '.' x int(100*($c/$count)/2) ), "\r";
                $i++;
            }
            $c++;

            if ( $continue_load ) {
                my $exists = $search_db->selectrow_array(
                    q[
                        select count(*) 
                        from   module_search 
                        where  module_name=?
                        and    table_name=?
                        and    record_id=?
                    ],
                    {},
                    ( $module, $table, $id )
                );

                next RECORD if $exists;
            }

            my $rec = $class->retrieve( $id );

            $num_records++;
            my $text = @columns 
                ? join $SPACE, 
                    grep { $_ ne 'NULL' }
                    map  { defined $_ ? $_ : () } 
                    map  { $rec->$_() } 
                    @columns
                : $EMPTY_STR
            ;

            my @ontologies = extract_ontology( $rec, $class->columns('All') );

            OTHER_TABLE:
            for my $other ( @index_also ) {
                my $other_table   = $other->{'table_name'};
                my $other_class   = $other->{'class'};
                my @other_columns = @{ $other->{'columns'} || [] } or next;

                for my $other_obj ( $rec->get_related($other_table) ) {
                    $text 
                        .= join( $SPACE, 
                        $EMPTY_STR,
                        grep { $_ ne 'NULL' }
                        map  { defined $_ ? $_ : () } 
                        $other_obj->get(@other_columns)
                    );

                    push @ontologies, extract_ontology( 
                        $other_obj, $other_class->columns('All')
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

                my $sth = $module_db->prepare( $sql );
                $sth->execute( @args );

                while ( my $d = $sth->fetchrow_hashref ) {
                    my @flds = keys %$d or next;

                    if ( 
                        my @d = 
                        uniq( map { defined $d->{$_} ? $d->{$_} : () } @flds ) 
                    ) {
                        $text .= join $SPACE, $EMPTY_STR, @d;
                    }

                     push @ontologies, extract_ontology( $d, @flds );
                }
            }

            $text =~ s/^\s+|\s+$//g; # trim
            $text =~ s/\s+/ /g;      # collapse spaces

            next if !$text;

            my $hs = HTML::Strip->new;
            $text = $hs->parse( $text );
            $hs->eof;

            my $ModSearch
                = Gramene::CDBI::GrameneSearch::ModuleSearch->find_or_create(
                    module_name => $module, 
                    table_name  => $table, 
                    record_id   => $rec->id
                )
            ;
            $ModSearch->record_text( $text );
            $ModSearch->update;

            ONT:
            for my $ontology_acc ( uniq( @ontologies ) ) {
                next unless $ontology_acc;

                my $OntologyType;
                if ( $ontology_acc =~ /^([A-Za-z_]+):/ ) {
                    my $ontology_type = $1;

                    ($OntologyType)
                        = Gramene::CDBI::GrameneSearch::OntologyType->search(
                            ontology_type => $ontology_type
                        ) or print STDERR "Bad ontology type: $ontology_type\n";
                }

                next ONT if !$OntologyType;

                my $Ontology
                = Gramene::CDBI::GrameneSearch::Ontology->find_or_create(
                    ontology_type_id => $OntologyType->id,
                    ontology_acc     => $ontology_acc,
                );

                my $SearchToTax =
                Gramene::CDBI::GrameneSearch::ModuleSearchToOntology->
                    find_or_create(
                        module_search_id => $ModSearch->id,
                        ontology_id      => $Ontology->id,
                    );
            }
        }

        print "\n";
    }
}

my $num_docs         = 0;
my $num_docs_skipped = 0;
if ( $process{'documents'} ) {
    my $gr_conf  = $config->get('gramene') or die "No 'gramene' config.\n";
    my $base_dir = $gr_conf->{'base_dir'} or die "No 'base_dir' setting.\n";
    my $doc_root = catdir( $base_dir, 'html' );
    my @files    = File::Find::Rule->file()
                                   ->name('*.html', '*.pdf', '*.doc')
                                   ->in($doc_root);

    print "Removing previous data for 'documents'.\n";
#    $search_db->do('truncate table doc_search');
    $search_db->do('delete from doc_search');

    my $hs          = HTML::Strip->new;
    my $current_num = 0;
    my $total_num   = scalar @files;

    FILE:
    for my $file ( @files ) {
        $current_num++;
        ( my $path = $file ) =~ s/^$doc_root//;
        print "$current_num/$total_num: $path\n";

        my $contents = $EMPTY_STR;
        my $title    = $EMPTY_STR;

        if ( $file =~ /\.html$/ ) {
            my $text  = slurp $file;
            $contents = $hs->parse( $text );
            $hs->eof;

            my $p = HTML::HeadParser->new;
            $p->parse( $text );
            $title = $p->header('Title');
        }
        elsif ( $file =~ /\.doc$/ ) {
            if ( -e $ANTIWORD ) {
                $contents = `$ANTIWORD $file`;
                my $xml   = `$ANTIWORD -x db $file`;
                if ( $xml =~ /<title>(.*?)<\/title>/ ) {
                    $title = $1;
                }
            }
            else {
                die "No antiword available at '$ANTIWORD'\n"; 
            }
        }
        elsif ( $file =~ /\.pdf$/ ) {
            if ( my $pdf = CAM::PDF->new( $file ) ) {
                for my $p ( 1..$pdf->numPages() ) {
                    if ( my $page = $pdf->getPageText( $p ) ) {
                        $contents .= $page;
                    }
                }

                my $pdf2  = PDF::API2->new( $file ) ;
                my %info  = $pdf2->info;
                $title    = $info{'Title'};
            }
            else {
                warn "No PDF: $CAM::PDF::errstr\n";
            }
        }
        else {
            warn "Don't know what to do with '$file'\n";
        }

        $contents =~ s/^\s+|\s+$//g;

        if ( $contents ) {
            $contents =~ s/[^[:ascii:]]//g;
            $contents =~ s/\s+/ /g;

            if ( !$title ) {
                my @lines = grep { /\w+/ } split /\n/, $contents;
                my $first_line_len = @lines ? length $lines[0] : 0;
                if ( $first_line_len > 1 && $first_line_len < 100 ) {
                    $title = $lines[0];
                }
                else {
                    $title = basename( $file );
                    $title =~ s/\..*$//;
                    $title =~ s/_/ /g;
                }
            }
            
            $search_db->do(
                q[
                    insert 
                    into   doc_search (path, title, contents) 
                    values (?, ?, ?)
                ],
                {},
                ( $path, $title, $contents )
            );
            $num_docs++;
        }
        else {
            $num_docs_skipped++;
        }
    }
}

printf 
    "Done, processed %s record%s in %s module%s, %s document%s (%s skipped).\n",
    commify($num_records),
    $num_records == 1 ? '' : 's',
    commify($num_modules),
    $num_modules == 1 ? '' : 's',
    commify($num_docs),
    $num_docs == 1 ? '' : 's',
    $num_docs_skipped,
;

# ----------------------------------------------------
sub extract_ontology {
    my ( $object, @fields ) = @_;

    my @ontologies;
    if ( my $ontology_acc = $object->{'ontology_acc'} ) {
        push @ontologies, $ontology_acc;
    }

    my %species_field = 
        map  { $_, 1 }
        grep { /^(genus|species|gramene_taxonomy_id|ncbi_tax(onomy)?_id)$/ } 
        @fields;

    if ( defined $species_field{'gramene_taxonomy_id'} ) {
        my $method = 'gramene_taxonomy_id';
        push @ontologies, UNIVERSAL::isa( $object, 'Gramene::CDBI' )
            ? $object->$method()
            : $object->{ $method };
    }

    if ( 
        my ($ncbi_tax_method) = grep { /^ncbi/ } keys %species_field
    ) {
        my $ncbi_tax = 
            UNIVERSAL::isa( $object, 'Gramene::CDBI' )
            ? $object->$ncbi_tax_method()
            : $object->{ $ncbi_tax_method }
        ;

        if ( $ncbi_tax ) {
            my $odb   = Gramene::Ontology::OntologyDB->new;
            push @ontologies, $odb->ncbi_tax_to_gr_tax( $ncbi_tax );
        }
    }

    if ( !@ontologies ) {
        my @species_fields = grep { defined $species_field{ $_ } } 
            qw[ genus species ];

        my @candidates;
        if ( UNIVERSAL::isa( $object, 'Gramene::CDBI' ) ) {
            @candidates = map { $object->$_() } @species_fields;
        }
        elsif ( ref $object eq 'HASH' ) {
            @candidates = map { $object->{ $_ } } @species_fields;
        }

        my $species = join( $SPACE, map { $_ || () } @candidates );

        if ( $species ) {
            my $odb = Gramene::Ontology::OntologyDB->new;
            my @term_ids = $odb->search(
                term_type    => 'Taxonomy',
                search_field => 'term_name',
                query        => $species,
            );

            if ( scalar @term_ids == 1 ) {
                my $Term =
                    Gramene::CDBI::Ontology::Term->retrieve($term_ids[0]);

                push @ontologies, $Term->term_accession;
            }
            elsif ( scalar @term_ids > 1 ) {
                warn "Several species look like '$species'\n";
            }
        }
    }

    return @ontologies;
}

__END__

# ----------------------------------------------------
=head1 NAME

load-gramene-search.pl - rebuild the MySQL table for text searches

=head1 SYNOPSIS

  load-gramene-search.pl [options]

Options:

  -l|--list           Show list of valid modules
  -m|--modules        Process only modules in comma-delimited list
  -r|--redo-tables    A comma-delimited list of tables to re-do;
                        this will only delete and reload the data 
                        for the one table, not the whole module
  -c|--continue       Allows you to pick up indexing in the event 
                        of a lost db connection mid-load; will skip
                        over records it has already cached

  --help              Show brief help and exit
  --man               Show full documentation

=head1 DESCRIPTION

This table truncates the "gramene_search" table in the "gramene_searchXX"
db and recreates the data needed for FULLTEXT searching.

To see a list of valid modules to select, use the "-l" option.  To
specify a particular set of modules to recache, use the "-m" option
with a comma-separated list.  If no modules are specified, you will be
presented a list from which you can select one module.

=head1 SEE ALSO

MySQL's FULLTEXT indexes.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2007 Cold Spring Harbor Laboratory

This library is free software;  you can redistribute it and/or modify 
it under the same terms as Perl itself.

=cut
