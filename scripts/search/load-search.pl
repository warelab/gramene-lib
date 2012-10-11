#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use File::Basename;
use File::Spec::Functions qw( catdir );
use File::Path;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( commify );
use HTML::Strip;
use List::MoreUtils qw( uniq );
use Lucy::Analysis::PolyAnalyzer;
use Lucy::Index::Indexer;
use Lucy::Plan::FullTextType;
use Lucy::Plan::Schema;
use Pod::Usage;
use Readonly;

Readonly my $ALL         => '[[all]]';
Readonly my $COMMA_SPACE => q{, };
Readonly my $EMPTY_STR   => q{};
Readonly my $SPACE          => q{ };

my $load_all  =  0;
my $show_list =  0;
my $modules   = '';
my ( $help, $man_page );
GetOptions(
    'a|all'      => \$load_all,
    'l|list'     => \$show_list,
    'm|module:s' => \$modules,
    'help'       => \$help,
    'man'        => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $gconf   = Grm::Config->new;
my @modules = $gconf->get('modules');

if ( $show_list ) {
    print join "\n",
        'Valid modules:',
        ( map { " - $_" } @modules ),
        '',
    ;
    exit 0;
}

my @do_modules;
if ( $modules ) {
    @do_modules = split /\s*,\s*/, $modules;
}
elsif ( $load_all ) {
    @do_modules = @modules;
}

if ( !@do_modules ) {
    pod2usage('Please indicate the modules or choose --all');
}

my $sconf         = $gconf->get('search');
my $path_to_index = $sconf->{'path_to_index'} or die "No path_to_index\n";

if ( $path_to_index !~ m{^/} ) {
    my $base_dir = $gconf->get('base_dir');
    $path_to_index = catdir( $base_dir, $path_to_index );
}

if ( !-d $path_to_index ) {
    mkpath $path_to_index;
}

my $num_records = 0;
MODULE:
for my $module ( uniq( @do_modules ) ) {
    next MODULE if $module eq 'search';

    my $module_index = catdir( $path_to_index, $module );

    #
    # Create Schema.
    #
    my $lucy_schema    = Lucy::Plan::Schema->new;
    my $polyanalyzer   = Lucy::Analysis::PolyAnalyzer->new( language => 'en' );
    my $title_type     = Lucy::Plan::FullTextType->new( 
        analyzer       => $polyanalyzer 
    );
    my $content_type   = Lucy::Plan::FullTextType->new(
        analyzer       => $polyanalyzer,
        highlightable  => 1,
    );
    my $url_type       = Lucy::Plan::StringType->new( indexed => 0, );
    my $cat_type       = Lucy::Plan::StringType->new( stored => 0, );

    $lucy_schema->spec_field( name => 'title',    type => $title_type );
    $lucy_schema->spec_field( name => 'content',  type => $content_type );
    $lucy_schema->spec_field( name => 'url',      type => $url_type );
    $lucy_schema->spec_field( name => 'category', type => $cat_type );

    # Create an Indexer object.
    my $indexer = Lucy::Index::Indexer->new(
        index    => $module_index,
        schema   => $lucy_schema,
        create   => 1,
        truncate => 1,
    ) or die "No indexer\n";

    my %index_only;
    for my $mod_name ( keys %{ $sconf->{'limit_index'} } ) {
        next if $module !~ /$mod_name/;

        my $tables = $sconf->{'limit_index'}{ $mod_name };

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

    print "index only = ", Dumper(\%index_only), "\n"; use Data::Dumper;
    next MODULE;

    my $db     = Grm::DB->new($module);
    my $dbh    = $db->dbh;
    my $schema = $db->dbic;

    TABLE:
    for my $source_name ( $schema->sources ) {
        my $result = $schema->resultset( $source_name );
        my $source = $result->result_source;
        my $table  = $source->name;

        if ( %index_only && !exists $index_only{ $table } ) {
            next TABLE;
        }

        my @id_fields = $source->primary_columns;

        if ( scalar @id_fields > 1 ) {
            print STDERR 
                "WARNING: Skipping table '$table'; more than 1 primary key (",
                join($COMMA_SPACE, @id_fields),
                ")\n";
            next TABLE;
        }

        my $id_field = shift @id_fields;

        if ( !$id_field ) {
            print STDERR "No PK in $source\n";
            next TABLE;
        };

        my @columns;
        if ( !%index_only || $index_only{ $table }{'fields'}->[0] eq $ALL ) {
            @columns = $source->columns;
        }
        else {
            my %valid = map { $_, 1 } $source->columns;
            @columns  = @{ $index_only{ $table }{'fields'} };

            if ( my @bad = grep { !$valid{ $_ } } @columns ) {
                die sprintf("Bad columns for %s: %s\n", 
                    $table, join(', ', @bad)
                );
            }
        }

        my @other_tables = @{ $index_only{ $table }{'other_tables'} || [] };

        if ( scalar @columns == 0 && scalar @other_tables == 0 ) {
            print STDERR 
                "No columns or other tables for '$source,' skipping.\n";
            next TABLE;
        }

        my @index_also;
#        for my $other ( @other_tables ) {
#            my $other_table  = $other->{'table_name'};
#            my @other_fields = @{ $other->{'fields'} || [] };
#            my $other_class    
#                = table_name_to_gramene_cdbi_class( $module, $other_table );
#            my $other_id_field = $other_class->columns('Primary');
#
#            if ( !$other_id_field ) {
#                print STDERR "No primary key in '$source'!\n";
#                next OTHER_TABLE;
#            };
#
#            my @other_has_a 
#                = keys %{ $other_class->meta_info('has_a') || {} };
#            my $other_skip  
#                = join '|', $other_id_field, @other_has_a;
#            my @other_columns;
#
#            if ( $other_fields[0] eq $ALL ) {
#                @other_columns
#                  = grep { !/($other_skip)/ } $other_class->columns('All');
#            }
#            else {
#                @other_columns = @other_fields;
#            }
#
#            push @index_also, {
#                table_name => $other_table,
#                class      => $other_class,
#                columns    => \@other_columns,
#            };
#        }


        my @additional_sql;
#        for my $section ( keys %{ $search_conf->{'index_sql'} } ) {
#            if ( $section =~ /([^.]+)[.]([^.]+)/ ) {
#                my ( $m_name, $t_name ) = ( $1, $2 );
#                next if $module !~ /$m_name/;
#                next if $table  ne $t_name;
#
#                if ( my $sql = $search_conf->{'index_sql'}{ $section } ) {
#                    @additional_sql = split /;/, $sql;
#                }
#            }
#        }

        my $count = $dbh->selectrow_array("select count(*) from $table");

        printf "\rProcessing %s record%s in '%s.%s'\n",
            commify($count),
            $count == 1 ? '' : 's',
            $module,
            $table;

        my $sth = $dbh->prepare("select $id_field from $table");
        $sth->execute;

        my ( $c, $i, $max ) = ( 1, 1, 50 );

        while ( my $id = $sth->fetchrow_array ) {
            if ( $i == $max ) {
                $i = 0;
            }
            else {
                print "$c ", ( '.' x int(100*($c/$count)/2) ), "\r";
                $i++;
            }
            $c++;

            my $rec = $result->find( $id ) 
                or die "Bad PK '$id' for $module $source_name\n";

            $num_records++;
            my $text = @columns 
                ? join $SPACE, 
                    grep { $_ ne 'NULL' }
                    map  { defined $_ ? $_ : () } 
                    map  { $rec->$_() } 
                    @columns
                : $EMPTY_STR
            ;

            my @ontologies;# = extract_ontology( $rec, $class->columns('All') );

#            OTHER_TABLE:
#            for my $other ( @index_also ) {
#                my $other_table   = $other->{'table_name'};
#                my $other_class   = $other->{'class'};
#                my @other_columns = @{ $other->{'columns'} || [] } or next;
#
#                for my $other_obj ( $rec->get_related($other_table) ) {
#                    $text 
#                        .= join( $SPACE, 
#                        $EMPTY_STR,
#                        grep { $_ ne 'NULL' }
#                        map  { defined $_ ? $_ : () } 
#                        $other_obj->get(@other_columns)
#                    );
#
##                    push @ontologies, extract_ontology( 
##                        $other_obj, $other_class->columns('All')
##                    );
#                }
#            }

#            SQL:
#            for my $sql ( @additional_sql ) {
#                my @args;
#                if ( $sql =~ /\?/ ) {
#                    push @args, $id;
#                }
#                elsif ( $sql =~ /\[(\w+)\]/ ) {
#                    my $fld = $1;
#                    if ( my $val = $rec->$fld() ) {
#                        $sql =~ s/\[.*?\]/?/;
#                        push @args, $val;
#                    }
#                    else {
#                        next SQL;
#                    }
#                }
#
#                my $sth = $module_db->prepare( $sql );
#                $sth->execute( @args );
#
#                while ( my $d = $sth->fetchrow_hashref ) {
#                    my @flds = keys %$d or next;
#
#                    if ( 
#                        my @d = 
#                        uniq( map { defined $d->{$_} ? $d->{$_} : () } @flds ) 
#                    ) {
#                        $text .= join $SPACE, $EMPTY_STR, @d;
#                    }
#
##                     push @ontologies, extract_ontology( $d, @flds );
#                }
#            }

            my $hs = HTML::Strip->new;
            $text = $hs->parse( $text );
            $hs->eof;

            $text =~ s/^\s+|\s+$//g; # trim
            $text =~ s/\s+/ /g;      # collapse spaces
            $text =~ /\A(.+?)^\s+(.*)/ms ; # not sure, stolen

            next if !$text;

            my $title = '';
            if ( my %list_columns = %{ $sconf->{'list_columns'} || {} } ) {
                while ( my ( $list_type, $list_def ) = each %list_columns ) {
                    my ( $list_module, $list_table ) = split /\./, $list_type;

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
            else {
                $title = substr $text, 0, 50;
            }


#            ONT:
#            for my $ontology_acc ( uniq( @ontologies ) ) {
#                next unless $ontology_acc;
#
#                my $OntologyType;
#                if ( $ontology_acc =~ /^([A-Za-z_]+):/ ) {
#                    my $ontology_type = $1;
#
#                    ($OntologyType)
#                        = Gramene::CDBI::GrameneSearch::OntologyType->search(
#                            ontology_type => $ontology_type
#                        ) or print STDERR "Bad ontology type: $ontology_type\n";
#                }
#
#                next ONT if !$OntologyType;
#
#                my $Ontology
#                = Gramene::CDBI::GrameneSearch::Ontology->find_or_create(
#                    ontology_type_id => $OntologyType->id,
#                    ontology_acc     => $ontology_acc,
#                );
#
#                my $SearchToTax =
#                Gramene::CDBI::GrameneSearch::ModuleSearchToOntology->
#                    find_or_create(
#                        module_search_id => $ModSearch->id,
#                        ontology_id      => $Ontology->id,
#                    );
#            }

            $indexer->add_doc({
                title    => $title,
                content  => $text,
                url      => join( '/', '', $module, $table, $id ),
                category => $db->db_name,
            });
            last if $i > 100;
        }

        print "\n";
    }

    print "Committing indexer\n";
    $indexer->commit;
}

print "Finished.\n";

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-search.pl - load Apache::Lucy search index for Gramene

=head1 SYNOPSIS

  load-search.pl [options]

Options:

  -a|--all    Process all modules
  -l|--list   Show a list of modules
  -m|--module Comma-separated list of modules to index

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Processes the modules indicated, indexing them for the Gramene search.

=head1 SEE ALSO

Apache::Lucy.

=head1 AUTHOR

Adapted from "indexer.pl" from the Apache Lucy sample Perl script by
Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
