#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use DateTime;
use Getopt::Long;
use Grm::DB;
use Grm::Config;
use Grm::Utils 'commify';
use Pod::Usage;
use Readonly;
use Text::TabularDisplay;

my ( $help, $man_page );
GetOptions(
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $conf = Grm::Config->new;
my $db   = Grm::DB->new('ontology');
my $dbh  = $db->dbh;
my $dt   = DateTime->now;

printf "Gramene Build %s\n", $conf->get('version');
printf "%s %s\n\n", $dt->month_name, $dt->year;

terms_by_term_type( $dbh );
assocs_by_term_type( $dbh );
assocs_by_assoc_type( $dbh );
assocs_by_assoc_type_and_term_type( $dbh );

# ----------------------------------------------------
sub assocs_by_assoc_type {
    my $dbh = shift;

    my $assocs_by_type = $dbh->selectall_arrayref(
        q[
            select   count(a.association_id) as count, t.type
            from     association a, 
                     association_object o,
                     association_object_type t
            where    a.association_object_id=o.association_object_id
            and      o.association_object_type_id=t.association_object_type_id
            group by 2
            order by 2
        ],
        { Columns => {} },
    );

    my $tab   = Text::TabularDisplay->new( 'Assoc Type', 'Number of Assocs');
    my $count = 0;
    for my $t ( @$assocs_by_type ) {
        $tab->add( 
            $t->{'type'},
            sprintf("%16s", commify($t->{'count'})),
        );
        $count += $t->{'count'};
    }

    $tab->add('Total', sprintf("%16s", commify($count)));

    say $tab->render, "\n";
}

# ----------------------------------------------------
sub assocs_by_assoc_type_and_term_type {
    my $dbh = shift;
    my $assoc_types = $dbh->selectall_arrayref(
        'select * from association_object_type', { Columns => {} }
    );

    for my $type ( @$assoc_types ) {
        my $assocs_by_type = $dbh->selectall_arrayref(
            q[
                select   count(t.term_id) as count, 
                         tt.term_type,
                         tt.prefix
                from     association a, 
                         association_object o,
                         term t,
                         term_type tt
                where    a.association_object_id=o.association_object_id
                and      o.association_object_type_id=?
                and      a.term_id=t.term_id
                and      t.term_type_id=tt.term_type_id
                and      tt.prefix is not null
                group by 2,3
                order by 2,3
            ],
            { Columns => {} },
            ( $type->{'association_object_type_id'} )
        );

        my $tab   = Text::TabularDisplay->new(
            $type->{'type'}, 'Number of Assocs'
        );
        my $count = 0;

        for my $t ( @$assocs_by_type ) {
            $tab->add( 
                sprintf("%s (%s)", $t->{'prefix'}, $t->{'term_type'}),
                sprintf("%16s", commify($t->{'count'})),
            );
            $count += $t->{'count'};
        }

        $tab->add('Total', sprintf("%16s", commify($count)));

        say $tab->render, "\n";
    }
}

# ----------------------------------------------------
sub assocs_by_term_type {
    my $dbh = shift;
    my $assocs_by_type = $dbh->selectall_arrayref(
        q[
            select   count(a.term_id) as count, tt.prefix, tt.term_type
            from     association a, term t, term_type tt
            where    a.term_id=t.term_id
            and      t.term_type_id=tt.term_type_id
            and      tt.prefix is not null
            group by 2,3
            order by 2,3
        ],
        { Columns => {} },
    );

    my $tab   = Text::TabularDisplay->new( 'Term Type', 'Number of Assocs');
    my $count = 0;
    for my $tt ( @$assocs_by_type ) {
        $tab->add( 
            sprintf("%s (%s)", $tt->{'prefix'}, $tt->{'term_type'}),
            sprintf("%16s", commify($tt->{'count'})),
        );
        $count += $tt->{'count'};
    }

    $tab->add('Total', sprintf("%16s", commify($count)));

    say $tab->render, "\n";
}

# ----------------------------------------------------
sub terms_by_term_type {
    my $dbh = shift;
    my $terms_by_type = $dbh->selectall_arrayref(
        q[
            select   count(t.term_id) as count, tt.prefix, tt.term_type
            from     term t, term_type tt
            where    t.term_type_id=tt.term_type_id
            and      tt.prefix is not null
            group by 2,3
            order by 2,3
        ],
        { Columns => {} },
    );

    my $tab   = Text::TabularDisplay->new( 'Term Type', 'Number of Terms');
    my $count = 0;
    for my $tt ( @$terms_by_type ) {
        $tab->add( 
            sprintf("%s (%s)", $tt->{'prefix'}, $tt->{'term_type'}),
            sprintf("%15s", commify($tt->{'count'})),
        );
        $count += $tt->{'count'};
    }

    $tab->add('Total', sprintf("%15s", commify($count)));

    say $tab->render, "\n";
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

ontology-stats.pl - prints ontology db statistics for FTP site

=head1 SYNOPSIS

  ontology-stats.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Not much else to say.

=head1 SEE ALSO

Grm::Ontology.

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
