#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use File::Path 'mkpath';
use File::Spec::Functions;
use Getopt::Long;
use Grm::Config;
use Grm::DB;
use Grm::Utils qw( timer_calc commify );
use HTML::Entities 'decode_entities';
use Pod::Usage;
use Readonly;
use Template;

Readonly my @FLDS => qw(
    id title prefix term_type accession name synonym description
);
Readonly my $SOLR => 'http://brie.cshl.edu:8983/solr/ontologies/update?'
    . 'commit=true&f.synonym.split=true';

my $out_dir   = cwd();
my $skip_file = '';
my ( $help, $man_page );
GetOptions(
    'o|out:s'   => \$out_dir,
    's|skips:s' => \$skip_file,
    'help'      => \$help,
    'man'       => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

if ( !-d $out_dir ) {
    mkpath $out_dir;
}

my $timer    = timer_calc();
my $db       = Grm::DB->new('ontology');
my $schema   = $db->schema;
my $out_file = catfile( $out_dir, 'ontologies.csv' );
my $term_num = 0;

open my $out, '>', $out_file;
print $out join( ',', @FLDS ), "\n";

print "Gathering ontology terms ... ";
my $count = $schema->resultset('Term')->count();
printf "there are %s.\n", commify($count);

my $skip_fn = sub {
    if ( $skip_file ) {
        open my $skips, '>', $skip_file;
        return sub { say $skips @_ };
    }
    else {
        return sub {}; # no-op
    }
}->();

my $gconf       = Grm::Config->new();
my $search_conf = $gconf->get('search');
my $title_tmpl  = '';

if ( my $title_def = $search_conf->{'title'}{'ontology.term'} ) {
    if ( $title_def =~ /^TT:(.+)/ ) {
        $title_tmpl = $1;
    }
}

my $tt          = Template->new();
my $num_skipped = 0;
TERM:
for my $Term ( $schema->resultset('Term')->all() ) {
    my $acc = $Term->term_accession || '';

    $term_num++;
    printf "%-70s\r", sprintf( 
        '%10s (%3d%%): %s', 
        commify($term_num), 
        $term_num == $count ? '100' : (($term_num/$count) * 100), 
        $acc 
    );

    my $skip;
    if ( !$acc ) {
        $skip = 'no accession';
    }
    elsif ( $acc !~ /^[A-Za-z_]+:\d+$/ ) {
        $skip = 'not a term'
    }
    elsif ( $Term->is_obsolete ) {
        $skip = 'is obsolete';
    }
    elsif ( !$Term->term_type->prefix ) {
        $skip = 'no prefix';
    }
    elsif ( !$Term->name ) {
        $skip = 'no name';
    }

    if ( $skip ) {
        $num_skipped++;
        $skip_fn->( join(': ', $skip, $acc) );
        next TERM;
    }

    my @syn;
    for my $Syn ( $Term->term_synonyms ) {
        push @syn, $Syn->term_synonym;
    }

    my $def = '';
    if ( my $Def = $Term->term_definition ) {
        $def = $Def->definition;
    }

    my $title = make_title( 
        tt       => $tt,
        template => $title_tmpl,
        module   => 'ontology',
        table    => 'term',
        object   => $Term,
    );

    print $out join( ',', map { clean($_) }
        join( '/', qw[ ontology term ], $Term->id ),
        $title,
        $Term->term_type->prefix,
        $Term->term_type->term_type,
        $acc,
        $Term->name,
        @syn ? join( ',', @syn ) : '',
        $def,
    ), "\n";
}

close $out;

printf "\nExported %s terms (skipped %s) in %s. Now do this:\n%s\n", 
    commify($term_num - $num_skipped), 
    commify($num_skipped), 
    $timer->(), 
    "curl '$SOLR' -H 'Content-type:application/csv' --data-binary \@" 
    . $out_file
;

# ----------------------------------------------------
sub clean {
    my $s = shift || '';

    $s =~ s/[\n\r]//g;       # no CR/LF
    $s =~ s/["']//g;         # kill quotes
    $s =~ s/^\s+|\s+$//g;    # trim
    $s =~ s/\s+/ /g;         # squish spaces
    $s =~ s/[[:^ascii:]]//g; # all non-ASCII text
    $s = decode_entities($s);

    return qq["$s"];
}

# ----------------------------------------------------
sub make_title {
    my %args     = @_;
    my $tt       = $args{'tt'};
    my $object   = $args{'object'};
    my $template = $args{'template'} || '';
    my $module   = $args{'module'}   || '';
    my $table    = $args{'table'}    || '';

    my $title = '';
    if ( $template ) {
        $tt->process(
            \$template,
            {
                object      => $object,
                module      => $module,
                table       => $table,
                object_type => $table,
            },
            \$title
        ) or $title = $tt->error;
    }
    else {
        $title = join(' ', map { $_ || () } 
            $module, 
            $table, 
            $object->id,
        );
    }

    return $title;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

load-ontologies.pl - creates a CSV file for Solr

=head1 SYNOPSIS

  load-ontologies.pl [-o out_dir]

Options:

  -o|--out     Output directory (default is "cwd")
  -s|--skips  File to write 
  --help       Show brief help and exit
  --man        Show full documentation

=head1 DESCRIPTION

Dumps the ontology db to a CSV file for Solr.

=head1 SEE ALSO

Solr.

=head1 AUTHOR

kclark E<lt>kclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Cold Spring Harbor Laboratory

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
