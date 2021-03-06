package Grm::Ontology;

=head1 NAME

Grm::Ontology - a Gramene module for Ontology db

=head1 SYNOPSIS

  use Grm::Ontology;

  my $odb = Grm::Ontology->new;

=head1 DESCRIPTION

Description of module goes here.

=cut

# ----------------------------------------------------

use strict;
use Carp qw( croak );
use Data::Dump 'dump';
use Grm::Config;
use Grm::DB;
use List::MoreUtils qw(uniq);
use Moose;
use Readonly;
use String::Trim qw(trim);
use Template;

no warnings 'redefine';

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
    default     => 'ontology',
);

has types => (
    is          => 'ro',
    lazy_build  => 1,
    isa         => 'ArrayRef[Str]',
    auto_deref  => 1,
);

has type_labels => (
    is          => 'ro',
    lazy_build  => 1,
    isa         => 'HashRef[Str]',
    auto_deref  => 1,
);

Readonly my %RELATIONSHIP_SYMBOLS => (
    is_a                 => '[i] ',
    part_of              => '[p] ',
    develops_from        => '[d] ',
    regulates            => '[r] ',
    positively_regulates => '[+r] ',
    negatively_regulates => '[-r] ',
);

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
sub _build_types {
    my $self   = shift;
    my $conf   = $self->config;
    my $oconf  = $conf->get('ontology');
    my $types  = $oconf->{'types'};

    return ref $types eq 'HASH' ? [ sort keys %$types ] : [];
}

# ----------------------------------------------------
sub _build_type_labels {
    my $self   = shift;
    my $conf   = $self->config;
    my $oconf  = $conf->get('ontology');
    my $labels = $oconf->{'types'};

    return ref $labels eq 'HASH' ? $labels : {};
}

# --------------------------------------------------
sub get_accession {
    my $self = shift;
    my $id   = shift;
    my $dbh  = $self->db->dbh;

    return $dbh->selectrow_array( 
        'select term_accession from term where term_id=?', {} , $id 
    );
}

# --------------------------------------------------
sub get_association_count_by_type {
    my $self    = shift;
    my $term_id = shift or die 'No term id';
    my $dbh     = $self->db->dbh;
    my @args    = ( $term_id );

    my $sql;
    if ( my $obj_type = shift ) {
        $sql = q[
            select count(a.association_id)
            from   association a, association_object o, 
                   association_object_type t
            where  a.term_id=?
            and    a.association_object_id=o.association_object_id
            and    o.association_object_type_id=t.association_object_type_id
            and    t.type=?
        ];
        push @args, $obj_type;
    }
    else {
        $sql = q[
            select count(*)
            from   association 
            where  term_id=?
        ];
    }

    my $count = $dbh->selectrow_array( $sql, {}, @args );

    return $count || 0;
}

# --------------------------------------------------
sub get_name {
    my $self = shift;
    my $id   = shift or die 'No id';
    my $dbh  = $self->db->dbh;

    return $dbh->selectrow_array( 
        'select name as term_name from term where term_id=?', {}, $id
    );
}

# --------------------------------------------------
sub get_relationship_type {
    # post: return $ISA, $PARTOF, $DEVELOPSFROM, or ""

    my ( $self, $parent, $child ) = @_;
    die "Invalid input in get_relationship_type2"
        unless ( defined $parent and defined $child );

    my $dbh = $self->db->dbh;

    return $dbh->selectrow_array(
        q[
            select type_name 
            from   term_to_term tt, relationship_type r
            where  r.relationship_type_id=tt.relationship_type_id
            and    term1_id=? 
            and    term2_id=?
        ],
        {},
        ( $parent, $child )
    );
}

# --------------------------------------------------
sub get_relationship_symbol {
    my ( $self, $parent, $child ) = @_;
    my $relationship = get_relationship_type( $self, $parent, $child );

    if ( $relationship && exists $RELATIONSHIP_SYMBOLS{$relationship}) {
        return $RELATIONSHIP_SYMBOLS{$relationship};
    }	

    return '';
}

# --------------------------------------------------
sub get_term_children_count {
    my $self = shift;
    my $id   = shift;
    my $dbh  = $self->db->dbh;

    return $dbh->selectrow_array(
        q[
            select count(*)
            from   term_to_term 
            where  term1_id=?
        ],
        {},
        $id
    );
}

# --------------------------------------------------
sub get_term_xrefs {
    my $self         = shift;
    my $id           = shift or die 'No term id for xrefs';
    my $opts_ref     = shift || {};
    my @xref_dbnames = map { $_ || () } (
        ref $opts_ref->{'xref_dbname'} eq 'ARRAY'
        ? @{ $opts_ref->{'xref_dbname'} } 
        : $opts_ref->{'xref_dbname'}
    );
    my $dbh      = $self->db->dbh;
    my $sql      = sprintf(
        q[
            SELECT xref_dbname, xref_key
            FROM   term_dbxref, dbxref
            WHERE  term_dbxref.dbxref_id = dbxref.dbxref_id
            AND    term_id = ?
            %s
        ],
        @xref_dbnames 
        ? 'AND xref_dbname in ('
            . join(', ', map { $dbh->quote($_) } @xref_dbnames) 
            . ')'
        : ''
    );

    my $data = $dbh->selectall_arrayref( $sql, { Columns => {} }, $id );

    if ( $opts_ref->{'as_hashref'} ) {
        return wantarray ? @$data : $data;
    }
    else {
        my @term_xrefs;
        for my $xref ( @$data ) {
            push @term_xrefs, "$xref->{xref_dbname}:$xref->{xref_key}";
        }

        return wantarray ? @term_xrefs : \@term_xrefs;
    }
}

# --------------------------------------------------
sub get_term_association_counts {
    my $self    = shift;
    my $term_id = shift or return;
    my $db      = $self->db->dbh;

    return $db->selectall_arrayref(
        q[
            select t.type as object_type,
                   concat_ws(' ', s.genus, s.species) as species,
                   s.common_name,
                   s.species_id,
                   count(a.association_id) as count
            from   association a, association_object o, 
                   association_object_type t, species s
            where  a.term_id=?
            and    a.association_object_id=o.association_object_id
            and    o.association_object_type_id=t.association_object_type_id
            and    o.species_id=s.species_id
            group by 1,2
            order by 1,2,3
        ],
        { Columns => {} },
        ( $term_id )
    );
}

# --------------------------------------------------
sub get_parents {
    my $self    = shift;
    my $id      = shift or die 'No term id';
    my $dbh     = $self->db->dbh;
    my $parents = $dbh->selectcol_arrayref(
        q[
            select   t2t.term1_id 
            from     term_to_term t2t, term t
            where    t2t.term2_id=?
            and      t2t.term2_id=t.term_id
            and      t.is_obsolete=0 
            order by t2t.term1_id
        ],
        {},
        ( $id )
    ); 
    
    return wantarray ? @$parents : $parents;
}       

# --------------------------------------------------
sub get_parents_recursive {
    my $self    = shift;
    my $id      = shift or die 'No term id';

    my @parents;
    for my $id ( $self->get_parents( $id ) ) {
        push @parents, $id, $self->get_parents_recursive( $id );
    }

    return uniq( @parents );
}
        
# --------------------------------------------------
sub get_children {
    my $self     = shift;
    my $id       = shift or die 'No term id';
    my $dbh      = $self->db->dbh;
    my $children = $dbh->selectcol_arrayref(
        q[  
            select t2t.term2_id
            from   term_to_term t2t, term t
            where  t2t.term1_id=?
            and    t2t.term2_id=t.term_id
            and    t.is_obsolete=0 
        ],
        {},
        ( $id )
    );

    return wantarray ? @$children : $children;
}

# --------------------------------------------------
sub get_children_recursive {
    my $self   = shift;
    my $tax_id = shift;
    my $db     = $self->db->dbh;

    my @children;
    for my $id ( $self->get_children( $tax_id ) ) {
        push @children, $id, $self->get_children_recursive( $id );
    }

    return uniq( @children );
}

# --------------------------------------------------
sub get_object_xref_type_display {
    my $self     = shift;
    my $obj_type = shift or return;
    my $conf     = $self->get_object_xref_url_conf( $obj_type );
    my $tmpl     = $conf->{'type_display'} or return;
    my $t        = Template->new;
    my $display  = '';

    $t->process(
        \$tmpl, { object_type => $obj_type }, \$display
    ) or $display = $t->error;

    return $display;
}

# --------------------------------------------------
sub get_object_xref_url {
    my $self           = shift;
    my %args           = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $object_type    = $args{'type'}
                      || $args{'object_type'} 
                      || '';
    my $db_object_id   = $args{'db_object_id'} 
                      || $args{'object_accession_id'} 
                      || $args{'object_acc'} 
                      || '';
    my $db_object_name = $args{'db_object_name'}
                      || $args{'object_name'} 
                      || $args{'name'} 
                      || '';
    my $db_object_sym  = $args{'db_object_symbol'}
                      || $args{'object_symbol'} 
                      || $args{'symbol'} 
                      || '';
    my $url_conf       = $self->get_object_xref_url_conf( $object_type );
    my $url_tmpl       = $url_conf->{'url'}     
                         or die "No URL for '$object_type'";
    my $display_tmpl   = $url_conf->{'object_display'} 
                         or die "No object display for '$object_type'";
    my $t              = Template->new;

    my ( $url, $display ) = ( '', '' );
    for my $tmp ( 
        [ \$url_tmpl    , \$url     ],
        [ \$display_tmpl, \$display ],
    ) {
        my $tmpl   = $tmp->[0];
        my $result = $tmp->[1];

        $t->process( 
            $tmpl, 
            { 
                object_type      => $object_type,
                db_object_id     => $db_object_id,
                db_object_name   => $db_object_name,
                db_object_symbol => $db_object_sym,
            }, 
            $result 
        ) or $display = $t->error;
    }

    return {
        url     => $url,
        display => $display,
    };
}

# --------------------------------------------------
sub get_object_xref_url_conf {
    my $self         = shift;
    my $object_type  = shift || '';
    my $config       = $self->config->get('ontology');
    my $obj_xref_url = $config->{'object_xref_url'};

    if ( !defined $obj_xref_url->{ $object_type } ) {
        for my $test_type ( keys %$obj_xref_url ) {
            if ( $object_type =~ /^$test_type/i ) {
                $object_type = $test_type;
                last;
            }
        }

        $object_type = 'default' if !defined $obj_xref_url->{ $object_type };
    }

    return $obj_xref_url->{ $object_type };
}

# --------------------------------------------------
sub get_type_label {
    my $self   = shift;
    my $type   = shift or return '';
    my %labels = $self->type_labels;

    return $labels{ lc $type } || '';
}

# --------------------------------------------------
sub get_term_associations {
    my $self       = shift;
    my %args       = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $id         = $args{'term_id'}    or die 'No term id';
    my $term_acc   = $args{'term_acc'}   || $args{'term_accession'} || '';
    my $obj_type   = $args{'type'}       || $args{'object_type'}    || '';
    my $order_by   = $args{'order_by'}   || 'species,object_type';
    my $dbh        = $self->db->dbh;

    my $sql = q[
        select t.term_accession,
               t.name as term_name,
               tt.term_type,
               ot.type as object_type,
               o.db_object_id,
               o.db_object_symbol,
               o.db_object_name,
               o.url,
               concat_ws(' ', s.genus, s.species) as species,
               s.common_name,
               s.species_id,
               a.evidence_code
        from   association a, 
               association_object o, 
               association_object_type ot, 
               term t, 
               term_type tt,
               species s
        where  a.term_id=t.term_id
        and    t.term_type_id=tt.term_type_id
        and    a.association_object_id=o.association_object_id
        and    o.association_object_type_id=ot.association_object_type_id
        and    o.species_id=s.species_id
        and    a.term_id=?
    ];

    my @params = ( $id );
    if ( $obj_type ) {
        $sql .= ' and ot.type=?';
        push @params, $obj_type;
    }

    if (my $species_id = $args{'species_id'}) {
        $sql .= ' and s.species_id=?';
        push @params, $species_id;
    }

    if (my $full_species = $args{'species'}) {
        my ($genus, $species) = split /\s+/, $full_species;
        $sql .= ' and s.genus=? and s.species=?';
        push @params, ($genus, $species);
    }

    $sql .= qq[
        group by term_accession, db_object_id, object_type 
        order by $order_by
    ];

    my $associations = $dbh->selectall_arrayref( 
        $sql, { Columns => {} }, @params 
    );

    return wantarray ? @$associations : $associations;
}

# ----------------------------------------------------
sub get_ontology_accession_prefixes {

=pod search

  my @prefixes = $odb->get_ontology_accession_prefixes;

Returns an array(ref) of "term_type.prefix".

=cut

    my $self = shift;
    my $dbh  = $self->db->dbh;
    my @prefixes = @{ $dbh->selectcol_arrayref(
        q[
            select distinct prefix 
            from   term_type 
            where  prefix is not null
            and    length(prefix) > 0
        ]
    ) };

    return wantarray ? @prefixes : \@prefixes;
}

# ----------------------------------------------------
sub search {

=pod search

  my @matches = $odb->search(
      query                  => 'oryza*',
      search_field           => 'term_name',
      term_type              => 'Taxonomy', 
      order_by               => 'term_name',
      include_obsolete_terms => 1,           # default '0'
  );

Returns an array(ref) of term_ids.

=cut

    my $self         = shift;
    my %args         = ref $_[0] eq 'HASH' 
                       ? %{ $_[0] } 
                       : scalar @_ == 1 ? ( query => $_[0] ) : @_;

    my $query        = trim($args{'query'})  or return;
    my $search_field = $args{'search_field'} || '';
    my $order_by     = $args{'order_by'}     || '';
    my $pref         = join('|', $self->get_ontology_accession_prefixes);

    #
    # If the query looks like a valid term ("GO:0009414"), look for
    # it in the term/synonym tables
    #
    if ( $query =~ /^($pref):\d+$/ ) {
        my $schema = $self->db->schema;
        my ($Term) 
            = $schema->resultset('Term')->search({term_accession => $query});

        if (!$Term) {
            my ($Syn) = $schema->resultset('TermSynonym')->search({
                term_synonym => $query
            });

            if ($Syn) {
                $Term = $Syn->term;
            }
        }

        if ($Term) {
            return $Term->id;
        }
    }

    #
    # Let's try Solr, then
    #
    my $search  = Grm::Search->new;
    my $results = $search->search(
        query     => $query,
        core      => 'ontologies',
        page_size => 1_000_000,
        page_num  => -1,
    );

    if ( $results->{'num_found'} ) {
        my @term_ids;
        for my $doc ( 
            @{ $results->{'core'}{'ontologies'}{'response'}{'docs'} }
        ) {
            my ($module, $table, $id) = split(/\//, $doc->{'id'}); 
            push @term_ids, $id;
        }

        return @term_ids;
    }

    #
    # Fall back to (slow) wildcard search on ontology db
    #
    my @matches;
    my $db  = $self->db;
    my $dbh = $db->dbh;

    my @type_ids = map { $_ || () } uniq(
        ref $args{'term_type_id'} eq 'ARRAY'
        ? @{ $args{'term_type_id'} }
        : split( /,/, $args{'term_type_id'} || '' )
    );

    my %valid_term_type = map { $_, 1 } $self->types;
    my @term_types;
    for my $term_type (
        uniq(
            ref $args{'term_type'} eq 'ARRAY'
            ? @{ $args{'term_type'} }
            : split( /\s*,\s*/, $args{'term_type'} || '' )
        )
    ) {
        if ( $term_type && $valid_term_type{ lc $term_type } ) {
            push @term_types, $term_type;
        }
    }

    my $prefixes = lc join( '|', keys %valid_term_type );
    my @queries  = uniq(
        ref $query eq 'ARRAY' ? @$query : split( /,\s*/, $query ) 
    );

    for my $qry ( @queries ) {
        my $cmp = $qry =~ s/\*/%/g ? 'like' : '=';

        my $sql = q[
            select     distinct t.term_id
            from       term t
            left join  term_definition d
            on         t.term_id=d.term_id
            left join  term_synonym s
            on         t.term_id=s.term_id
            inner join term_type tt
            on         t.term_type_id=tt.term_type_id
        ];
    
        my @sql_args;
        if ( $search_field ) {
            $sql .= " where $search_field $cmp ? ";
            @sql_args = ( $qry );
        }
        elsif ( $qry =~ /^($prefixes):/i ) {
            $sql = qq[
                select  distinct t.term_id
                from    term t, term_synonym s
                where   t.term_id=s.term_id
                and     ( 
                    t.term_accession $cmp '$qry' 
                    or s.term_synonym $cmp '$qry'
                )
            ];
        }
        else {
            $sql .= qq[
                where  (
                       t.term_accession $cmp ?
                  or   t.name $cmp ?
                  or   d.definition $cmp ?
                  or   s.term_synonym $cmp ?
                )
            ];

            @sql_args = ( $qry, $qry, $qry, $qry );
        }

        if ( scalar @type_ids == 1 ) {
            $sql .= ' and t.term_type_id=' . $type_ids[0] . ' ';
        }
        elsif ( @type_ids ) {
            $sql .= ' and t.term_type_id in (' 
                 .  join( ', ', @type_ids ) 
                 . ') ';
        }

        if ( scalar @term_types == 1 ) {
            $sql .= q[ and tt.prefix='] . $term_types[0] . q[' ];
        }
        elsif ( @term_types ) {
            $sql .= ' and tt.prefix in ('
                 .  join( ', ', map {qq['$_']} @term_types ) . ') ';
        }

        if ( !$args{'include_obsolete_terms'} ) {
            $sql .= ' and t.is_obsolete=0 ';
        }

        if ( $order_by ) {
            $sql .= " order by $order_by ";
        }

        my $data = $dbh->selectcol_arrayref( $sql, {}, @sql_args );

        if ( @$data > 0 ) {
            push @matches, @$data;
        }
        elsif ( $qry !~ /[*%]$/ && $qry !~ /^[A-Za-z_]+:\d+$/ ) {
            push @queries, "$qry*";
        }
    }

    return wantarray ? @matches : \@matches;
}

# ----------------------------------------------------
sub search_accessions {

=pod search_accessions

    my $Term = $odb->strict_search('TO:0000324');

Only search for accessions and synonyms (faster);

=cut

    my $self   = shift;
    my $acc    = shift or return;
    my $schema = $self->db->schema;
    my $pref   = join('|', $self->get_ontology_accession_prefixes);

    if ( $acc !~ /^($pref):\d+$/ ) {
        return;
    }

    my ($Term) = $schema->resultset('Term')->search({term_accession => $acc});

    if (!$Term) {
        my ($Syn) = $schema->resultset('TermSynonym')->search({
            term_synonym => $acc
        });
        if ($Syn) {
            $Term = $Syn->term;
        }
    }

    return $Term;
}

# ----------------------------------------------------
sub search_xref {
    my $self     = shift;
    my $query    = shift;
    my $db       = $self->db;
    my $dbh      = $db->dbh;
    my $term_ids = $dbh->selectcol_arrayref(
        q[
            select t.term_id
            from   term t, term_dbxref td, dbxref d
            where  t.term_id=td.term_id
            and    td.dbxref_id=d.dbxref_id
            and    d.xref_key=?
        ],
        {},
        ( $query )
    );

    my $dbic  = $db->dbic;
    my $rs    = $dbic->resultset('Term');

    return map { $rs->find( $_ ) } @$term_ids;
}

# ----------------------------------------------------
sub obsolete_term_alternates {
    my $self       = shift;
    my %args       = scalar @_ == 1 ? ( term_id => shift ) : @_;
    my $term_id    = $args{'term_id'}  || '';
    my $term_acc   = $args{'term_acc'} || $args{'term_accession'} || '';

    unless ( $term_id || $term_acc ) {
        die 'Need term_id or term_acc';
    }

    if ( !$term_id && $term_acc ) {
        my $schema = $self->db->dbic;
        my ($Term) = $schema->resultset('Term')->find({
            term_accession => $term_acc
        });

        if ( $Term ) {
            $term_id = $Term->id;
        }
    }

    my $amigo_db   = Grm::DB->new('amigo');
    my $alternates = $amigo_db->dbh->selectall_arrayref(
        q[  
            select     child.term_type as ontology,
                       child.acc as child_acc,
                       child.name as child_name,
                       rel.acc as rel_acc,
                       parent.term_type as parent_type,
                       parent.acc as parent_acc,
                       parent.name as parent_name
            from       term as child
            inner join term2term_metadata
                       on (child.id=term2_id)
            inner join term as parent
                       on (parent.id=term1_id)
            inner join term as rel
                       on (rel.id=relationship_type_id)
            where      term2term_metadata.term2_id=?
        ],
        { Columns => {} },
        $term_id,
    );

    return wantarray ? @$alternates : $alternates;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

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
