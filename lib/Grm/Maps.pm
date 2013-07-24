package Grm::Maps;

=head1 NAME

Grm::Maps - API to Gramene maps module

=head1 SYNOPSIS

  use Grm::Maps;

=head1 DESCRIPTION

Description of module goes here.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

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
use Readonly;
use List::MoreUtils 'uniq';
use Grm::Utils qw( 
    commify parse_words 
);
#expand_taxonomy format_reference
use Moose;

has config => (
    is         => 'rw',
    isa        => 'Grm::Config',
    lazy_build => 1,
);

has db => (
    is         => 'rw',
    isa        => 'Grm::DB',
    lazy_build => 1,
);

has module_name => (
    is          => 'ro',
    isa         => 'Str',
    default     => 'maps',
);

Readonly my $MARKER_NAME_WITH_SYN_TYPE => qr/
    \A                 # start of line
    ["]?               # double-quote (optional)
    (.+)               # anything (captured)
    \s+                # one or more spaces
    [[]{2}             # two left square brackets
    (?:synonym_type=)? # optional "synonym_type="
    (\w+)              # something (captured)
    []]{2}             # two right square brackets
    ["]?               # double-quote (optional)
    \z                 # end of line
/xms;

# ----------------------------------------------------
sub BUILD {
    my $self = shift;
    my $args = shift || {};

    if ( my $config = $args->{'config'} ) {
        $self->config( $config );
    }
}

# ----------------------------------------------------
sub _build_config {
    my $self = shift;

    return Grm::Config->new;
}

# ----------------------------------------------------
sub _build_db {
    my $self  = shift;

    return Grm::DB->new( $self->module_name );
}

# ----------------------------------------------------
sub feature_search {

=pod

=head2 feature_search 

  my $features = $mdb->feature_search( 
      feature_id           => 8832,    # takes ultimate precedence
      feature_name         => 'RG*, RZ*',
      feature_acc          => 'BZ591388',
      feature_type         => 'RFLP',    # or ['RFLP', 'AFLP']
      feature_type_id      => 18,        # or [18,19]
      exclude_feature_type => 'QTL,Gene',# or ['RFLP', 'AFLP']
      synonym_type        => 'GENBANK_ACCESSION', # or ['...', '...']
      synonym_type_id     => 18,        # or [18,19]
      species_id          => 3,         # or [3,4]
      taxonomy_id         => 'GR_tax:00174', # or ['...','...']
      taxonomy            => 'rice, wheat',
      tag                 => 'fosmid',
      map_set_id          => 4,         # or [3,4]
      species             => 'rice',    # or ['rice', 'sorghum']
      genus               => 'Oryza',   # or ['Oryza', 'Zea']
      feature_acc         => 'cu-dh-2001-12-27',
      is_sequence         => 1,         # for "feature_type.is_sequence"
      xref_type           => 'GenBank',
      xref_value          => 'AA231754',
      ontology            => 'PO:0006480',
      order_by            => 'type',
      search_only_primary_name => 1, 

      max_returned        => 500,    # will cause an error if results exceed
      limit_no            => 25,     # page size
      current_page        => 1,      # used with "limit_no"
  );

Returns all the features matching the parameters given.

=cut

    my ( $self, %args )  = @_;
    my $feature_id       = $args{'feature_id'}   || $args{'feature_id'}   ||  0;
    my $feature_name     = $args{'feature_name'} || $args{'feature_name'} || '';
    my $feature_acc      = $args{'feature_acc'}  || $args{'feature_acc'}  || '';
    my $synonym_type     = $args{'synonym_type'}     || '';
    my $xref_type        = $args{'xref_type'}        || '';
    my $xref_value       = $args{'xref_value'}       || '';
    my $cmap_feature_acc = $args{'mapping_acc'} 
                        || $args{'cmap_feature_acc'}
                        || $args{'cmap_feature_aid'} || '';
    my $is_sequence      = $args{'is_sequence'}      ||  0;
    my $max_returned     = $args{'max_returned'}     ||  0;
    my $order_by         = $args{'order_by'}         || ''; # 'feature_name';
    my $current_page     = $args{'current_page'}     ||  1;
    my $limit_no         = $args{'limit_no'}         ||  0;
    my $timeout          = $args{'timeout'}          ||  0;
    my $search_only_primary_name = $args{'search_only_primary_name'} || 0;

    my @feature_types = map { $_ || () } uniq(
        ref $args{'feature_type'} eq 'ARRAY'
        ? @{ $args{'feature_type'} } 
        : split( /,/, $args{'feature_type'} || '')
    );

    my @exclude_feature_types = map { $_ || () } uniq(
        ref $args{'exclude_feature_type'} eq 'ARRAY'
        ? @{ $args{'exclude_feature_type'} } 
        : split( /,/, $args{'exclude_feature_type'} || '')
    );

    my @species = map { $_ || () } uniq(
        ref $args{'species'} eq 'ARRAY'
        ? @{ $args{'species'} } 
        : split( /,/, $args{'species'} || '' )
    );

    my @feature_type_ids  = map { $_ || () } uniq(
        ref $args{'feature_type_id'} eq 'ARRAY' 
        ? @{ $args{'feature_type_id'} } 
        : split( /,/, $args{'feature_type_id'} || '' )
    );

    my @synonym_types = map { $_ || () } uniq(
        ref $args{'synonym_type'} eq 'ARRAY'
        ? @{ $args{'synonym_type'} } 
        : split( /,/, $args{'synonym_type'} || '' )
    );

    my @synonym_type_ids  = map { $_ || () } uniq(
        ref $args{'synonym_type_id'} eq 'ARRAY' 
        ? @{ $args{'synonym_type_id'} } 
        : split( /,/, $args{'synonym_type_id'} || '' )
    );

    my @species_ids = map { $_ || () } uniq(
        ref $args{'species_id'} eq 'ARRAY' 
        ? @{ $args{'species_id'} } 
        : split( /,/, $args{'species_id'} || '' )
    );

    my @taxonomy_ids = map { $_ || () } uniq(
        ref $args{'taxonomy_id'} eq 'ARRAY' 
        ? @{ $args{'taxonomy_id'} } 
        : split( /,/, $args{'taxonomy_id'} || '' )
    );

    my @taxonomy = map { $_ || () } uniq(
        ref $args{'taxonomy'} eq 'ARRAY' 
        ? @{ $args{'taxonomy'} } 
        : split( /,/, $args{'taxonomy'} || '' )
    );

    my @genera = map { $_ || () } uniq(
        ref $args{'genus'} eq 'ARRAY' 
        ? @{ $args{'genus'} } 
        : split( /,/, $args{'genus'} || '' )
    );

    my @map_set_ids = ref $args{'map_set_id'} eq 'ARRAY' 
        ? @{ $args{'map_set_id'} } 
        : split( /,/, $args{'map_set_id'} || '' )
    ;

    my @map_set_species_ids = map { $_ || () } uniq(
        ref $args{'map_set_species_id'} eq 'ARRAY' 
        ? @{ $args{'map_set_species_id'} } 
        : split( /,/, $args{'map_set_species_id'} || '' )
    );

    my @ontology_accs = ref $args{'ontology'} eq 'ARRAY' 
        ? @{ $args{'ontology'} } 
        : split( /,/, $args{'ontology'} || '' )
    ;

    my @tags = map { $_ || () } uniq(
        ref $args{'tag'} eq 'ARRAY' 
        ? @{ $args{'tag'} } 
        : split( /,/, $args{'tag'} || '' )
    );

    for my $ms_species_id ( @map_set_species_ids ) {
        for my $ms ( 
            Grm::DBIC::Maps::MapSet->search(
                { species_id => $ms_species_id }
            ) 
        ) {
            push @map_set_ids, $ms->id;
        }
    }

    @map_set_ids = map { $_ || () } uniq( @map_set_ids );

    my $db  = $self->db or return;
    my $dbh = $db->dbh;

    if ( @feature_types && !@feature_type_ids ) {
        for my $feature_type ( @feature_types ) {
            next unless $feature_type;
            my $id = $self->get_feature_type_id( $feature_type ) or next;
            push @feature_type_ids, $id;
        }
    }

    my @ontology_term_ids;
    for my $ontology_acc ( @ontology_accs ) {
        next unless $ontology_acc;
        push @ontology_term_ids, @{ 
            $dbh->selectcol_arrayref(
                q[
                    select ontology_term_id
                    from   ontology_term
                    where  term_accession=?
                ],
                {},
                ( $ontology_acc )
            ) 
        };
    }

    my @exclude_feature_type_ids;
    for my $feature_type ( @exclude_feature_types ) {
        next unless $feature_type;
        my $id = $self->get_feature_type_id( $feature_type ) or next;
        push @exclude_feature_type_ids, $id;
    }

    if ( @species && !@species_ids ) {
        for my $species ( @species ) {
            next unless $species;
            my $id = $self->get_species_id( $species ) or next;
            push @species_ids, $id;
        }
    }

    if ( @taxonomy ) {
        my %tax = expand_taxonomy( \@taxonomy );
            
        push @taxonomy_ids, @{ $tax{'accessions'} || [] };
    }

    if ( @taxonomy_ids ) {
        push @species_ids, $self->get_species_id_by_taxonomy_id(\@taxonomy_ids);
    }

    @species_ids = uniq( @species_ids );

    if ( @synonym_types && !@synonym_type_ids ) {
        for my $synonym_type ( @synonym_types ) {
            next unless $synonym_type;
            my $id = $self->get_synonym_type_id( $synonym_type ) or next;
            push @synonym_type_ids, $id;
        }
    }

    for my $genus ( @genera ) {
        for my $species (
            Grm::DBIC::Maps::Species->search_like(
                { species => "$genus%" }
            )
        ) {
            push @species_ids, $species->id;
        }
    }

    my @feature_names;
    if ( ref $feature_name eq 'ARRAY' ) {
        @feature_names = uniq( @$feature_name );
    }
    else {
        @feature_names = uniq(
            map { 
                s/^GI://g;      # remove "GI:" for GenBank GIs
                s/,//g;         # remove commas
                s/^\s+|\s+$//g; # remove leading/trailing whitespace
                s/"//g;         # remove double quotes (")
                s/'/\\'/g;      # backslash escape single quotes
                $_ || ()
            }
            parse_words( $feature_name )
        );
    }

    if ( @feature_names > 1 ) {
        @feature_names = grep { !/^[*%]$/ } @feature_names;
    }

    push @feature_names, '*' unless @feature_names;

    my @summary_params;

    my ( $features, $count );
    if ( $feature_id ) {
        my $sth = $dbh->prepare(
            qq[
                select    m.feature_id, 
                          m.feature_acc,
                          syn.feature_name, 
                          sp.species_id,
                          sp.species,
                          t.feature_type_id,
                          t.feature_type
                from      feature m,
                          feature_synonym syn,
                          species sp,
                          feature_type t
                where     m.feature_id=?
                and       m.display_synonym_id=syn.feature_synonym_id
                and       m.feature_type_id=t.feature_type_id
                and       m.species_id=sp.species_id
            ]
        );

        $sth->execute( $feature_id );
        my $feature = $sth->fetchrow_hashref 
                     or croak("Bad feature id ($feature_id)");

        @$features = ( $feature );
    }
    elsif ( $feature_acc ) {
        my $cmp;
        if ( $feature_acc =~ s/\*/%/g ) {
            @summary_params = "like " . $dbh->quote($feature_acc);
            $cmp            = 'like';
        }
        else {
            @summary_params = "is " . $dbh->quote($feature_acc);
            $cmp            = '=';
        }

        $features = $dbh->selectall_arrayref(
            qq[
                select m.feature_id, 
                       m.feature_acc,
                       syn.feature_name, 
                       sp.species_id,
                       sp.species,
                       t.feature_type_id,
                       t.feature_type
                from   feature m,
                       feature_synonym syn,
                       species sp,
                       feature_type t
                where  m.feature_acc $cmp ?
                and    m.display_synonym_id=syn.feature_synonym_id
                and    m.feature_type_id=t.feature_type_id
                and    m.species_id=sp.species_id
            ],
            { Columns => {} },
            $feature_acc
        );
    }
    elsif ( $cmap_feature_acc ) {
        @summary_params = ( $cmap_feature_acc =~ /\*/
                ? "like " . $dbh->quote($cmap_feature_acc)
                : "is " . $dbh->quote($cmap_feature_acc),
        );

        $features = $dbh->selectall_arrayref(
            sprintf(
                qq[
                    select m.feature_id, 
                           m.feature_acc,
                           syn.feature_name, 
                           sp.species_id,
                           sp.species,
                           t.feature_type_id,
                           t.feature_type
                    from   mapping mp,
                           feature_synonym syn,
                           species sp,
                           feature_type t,
                           feature m 
                    where  mp.mapping_acc %s
                    and    mp.feature_id=m.feature_id
                    and    m.display_synonym_id=syn.feature_synonym_id
                    and    m.feature_type_id=t.feature_type_id
                    and    m.species_id=sp.species_id
                    %s
                ],
                $cmap_feature_acc =~ s/\*/%%/g 
                    ? "like ?"
                    : "=?",
                $order_by ? "order by $order_by " : ''
            ),
            { Columns => {} },
            $cmap_feature_acc
        );
    }
    elsif ( $xref_type ) {
        @summary_params = ( 
            "with a cross-reference of type '$xref_type'"
        );

        my $sql = sprintf(
             q[
                select   m.feature_id, 
                         m.feature_acc,
                         syn.feature_name, 
                         sp.species_id,
                         sp.species,
                         t.feature_type_id,
                         t.feature_type
                from     xref_type xt,
                         xref x,
                         feature m, 
                         feature_synonym syn,
                         species sp,
                         feature_type t
                where    xt.xref_type=?
                and      xt.xref_type_id=x.xref_type_id
                and      x.table_name=?
                %s
                and      x.record_id=m.feature_id
                and      m.display_synonym_id=syn.feature_synonym_id
                and      m.feature_type_id=t.feature_type_id
                and      m.species_id=sp.species_id
                %s
            ],
            $xref_value ? 'and x.xref_value=?' : '',
            $order_by ? "order by $order_by " : ''
        );
        my @args = ( $xref_type, 'feature' );
        push @args, $xref_value if $xref_value;

        $features = $dbh->selectall_arrayref( $sql, { Columns => {} }, @args );
    }
    elsif ( @feature_names ) {
        my $sql;
        my $fields = q[ 
            distinct m.feature_id, 
            m.feature_acc,
            syn2.feature_name, 
            sp.species_id,
            sp.species,
            t.feature_type_id,
            t.feature_type
        ];

        if ( scalar @feature_names == 1 && $feature_names[0] eq '*' ) {
            $sql = q[
                select    %s
                from      feature m, 
                          feature_synonym syn2,
                          species sp,
                          feature_type t
                where     m.display_synonym_id=syn2.feature_synonym_id
                and       m.feature_type_id=t.feature_type_id
                and       m.species_id=sp.species_id
            ];
        }
        else {
            my @conditions;
            for my $name ( @feature_names ) {
                my $cmp = q{=};

                if ( $name =~ $MARKER_NAME_WITH_SYN_TYPE ) {
                    $name = $1;
                }

                if ( $name =~ s/\\\*/*/g ) {
                    # this allows actual asterisks in names
                    # to be backslash-escaped, e.g., "ad\*-N377B"
                    ;
                }
                elsif ( $name =~ s/\*/%%/g || $name =~ s/%/%%/ ) {
                    $cmp = 'like';
                }

                push @summary_params, "feature name $cmp &quot;$name&quot;";
                push @conditions, "syn1.feature_name $cmp " . 
                    $dbh->quote($name);
            }

            my $where = ' where (' . shift @conditions;
            $where   .= " or $_ " for @conditions;
            $where   .= ') ';

            $sql = qq[
                select    %s
                from      feature m, 
                          feature_synonym syn1,
                          feature_synonym syn2,
                          species sp,
                          feature_type t
                $where   
                and       syn1.feature_id=m.feature_id
                and       m.display_synonym_id=syn2.feature_synonym_id
                and       m.feature_type_id=t.feature_type_id
                and       m.species_id=sp.species_id
            ];
        }

#        if ( @ontology_term_ids ) {
#            my $ont_where = @ontology_term_ids == 1 
#                ? "=" . $db->quote($ontology_term_ids[0])
#                : ' in (' . join(',', map {$db->quote($_)} @ontology_term_ids) . ')'
#            ;
#            $sql =~ s/\bwhere/
#                , feature_to_ontology_term m2o
#                where m.feature_id=m2o.feature_id
#                and   m2o.ontology_term_id $ont_where
#                and   
#            /;
#
#            push @summary_params, 
#                "feature associated to " . join(', ', @ontology_accs);
#        }

        if ( @map_set_ids ) {
            $sql =~ s/\bwhere/
                , mapping, map
                where m.feature_id=mapping.feature_id
                and   mapping.map_id=map.map_id
                and 
            /;
        }

        for my $map_set_id ( @map_set_ids ) {
            my $MapSet = Grm::DBIC::Maps::MapSet->retrieve(
                $map_set_id
            );

            push @summary_params, sprintf(
                "feature mapped to %s %s map set &quot;%s&quot;",
                $MapSet->species->species,
                $MapSet->map_type->map_type,
                $MapSet->map_set_name,
            );
        }

        if ( scalar @map_set_ids == 1 ) {
            $sql .= 'and map.map_set_id=' . $dbh->quote($map_set_ids[0]) . ' ';
        }
        elsif ( @map_set_ids ) {
            $sql .= 'and map.map_set_id in (' .
                    join( ', ', map {$dbh->quote($_)} @map_set_ids ) . 
            ') ';
        }

#        if ( @tags ) {
#            @summary_params = ( sprintf(
#                'tagged as %s', join( ', ', map { "&quot;$_&quot;" } @tags )
#            ) );
#
#            my $tag_arg = join( ', ', map { $db->quote($_) } @tags );
#
#            $sql =~ s/\bwhere/
#                , tag, tag_to_feature t2m
#                where m.feature_id=t2m.feature_id
#                and   t2m.tag_id=tag.tag_id
#                and   tag.tag in ($tag_arg)
#                and  
#            /;
#        }

        for my $feature_type_id ( @feature_type_ids ) {
            my $FeatureType = Grm::DBIC::Maps::FeatureType->retrieve(
                $feature_type_id
            );

            push @summary_params, sprintf(
                "feature type of &quot;%s&quot;",
                $FeatureType->feature_type
            );
        }

        for my $feature_type_id ( @exclude_feature_type_ids ) {
            my $FeatureType = Grm::DBIC::Maps::FeatureType->retrieve(
                $feature_type_id
            );

            push @summary_params, sprintf(
                "feature type not of &quot;%s&quot;",
                $FeatureType->feature_type
            );
        }

        if ( scalar @feature_type_ids == 1 ) {
            $sql .= 'and m.feature_type_id=' . $dbh->quote($feature_type_ids[0]) . ' ';
        }
        elsif ( @feature_type_ids ) {
            $sql .= 'and m.feature_type_id in (' .
                    join( ', ', map{$dbh->quote($_)} @feature_type_ids ) . ') ';
        }
        else{
            if ( scalar @exclude_feature_type_ids == 1 ) {
                $sql .= 'and m.feature_type_id!='
                     .  $dbh->quote($exclude_feature_type_ids[0])
                     .  ' ';
            }
            elsif ( @exclude_feature_type_ids ) {
                $sql .= 'and m.feature_type_id not in (' 
                     .  join( ', ', map{$dbh->quote($_)} @exclude_feature_type_ids ) 
                     . ') ';
            }
        }

        for my $species_id ( @species_ids ) {
            my $Species = Grm::DBIC::Maps::Species->retrieve(
                $species_id
            );

            push @summary_params, sprintf(
                "feature from species &quot;%s&quot;",
                $Species->species
            );
        }

        if ( scalar @species_ids == 1 ) {
            $sql .= 'and m.species_id=' . $dbh->quote($species_ids[0]) . ' ';
        }
        elsif ( @species_ids ) {
            $sql .= 'and m.species_id in (' .
                    join( ', ', map{$dbh->quote($_)} @species_ids ) . 
            ') ';
        }

        for my $synonym_type_id ( @synonym_type_ids ) {
            my $SynonymType = Grm::DBIC::Maps::SynonymType->retrieve(
                $synonym_type_id
            );

            push @summary_params, sprintf(
                "feature name of type &quot;%s&quot;",
                $SynonymType->synonym_type
            );
        }

        if ( scalar @synonym_type_ids == 1 ) {
            $sql .= 'and syn1.synonym_type_id='.$dbh->quote($synonym_type_ids[0]).' ';
        }
        elsif ( @synonym_type_ids ) {
            $sql .= 'and syn1.synonym_type_id in (' .
                    join( ', ', map{$dbh->quote($_)} @synonym_type_ids ) . 
            ') ';
        }

        if ( $search_only_primary_name ) {
            push @summary_params, 'searching only primary name';
            $sql .= 'and m.display_synonym_id=syn2.feature_synonym_id ';
        }

        my $count_sql = sprintf( $sql, 'count(distinct m.feature_id) as count' );
        $count        = $dbh->selectrow_array( $count_sql );

        if ( $max_returned ) {
            croak(
                'Found ' . commify($count) . ' features; maximum of ' .
                commify($max_returned) . ' allowed. Please narrow your search.'
            ) if $count > $max_returned;
        }

        $sql .= " order by $order_by " if $order_by;

        if ( $limit_no > 0 && $count > $limit_no ) {
            my $start = $current_page == 1 
                ? 0 
                : ( ( $current_page - 1 ) * $limit_no ) - 1;
            $sql .= " limit $start, $limit_no";
        } 

        my $select_sql = sprintf( $sql, $fields );
        eval {
            local $SIG{'ALRM'} = sub { 
                die "Marker search timed out after $timeout seconds\n" 
            };
            alarm $timeout if $timeout && $^O !~ /Win32/i;
            $features = $dbh->selectall_arrayref($select_sql, { Columns => {} });
            alarm 0 unless $^O =~ /Win32/i;
        }; 

        if ( my $err = $@ ) {
            print STDERR __PACKAGE__, "::feature_search error: ",
                "$err\nSQL=\n$select_sql";
            croak( $err );
            return wantarray ? () : undef;
        }
    }

    return $limit_no 
        ? ( $count || scalar @{ $features }, $features, \@summary_params ) 
        : wantarray ? @$features : $features;
}

1;
