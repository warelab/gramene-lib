package Grm::Utils;

use strict;
use CGI;
use Carp qw( carp croak );
use Data::Dumper;
use Data::Pageset;
use Grm::Config;
use List::Util qw( max );
use List::MoreUtils qw( uniq );
use Log::Dispatch::File;
use Readonly;
use Template::Constants qw( :chomp );

Readonly my $EMPTY_STR => q{};

require Exporter;

use vars qw( @EXPORT @EXPORT_OK );

use base 'Exporter';

my @subs = qw[ 
    commify
    get_logger
    gramene_cdbi_class_to_module_name
    gramene_cdbi_class_to_table_name
    iterative_search_values
    match_context
    module_name_to_gdbic_class
    pager
    parse_words
    table_name_to_gdbic_class
];

@EXPORT_OK = @subs;
@EXPORT    = @subs;

# ----------------------------------------------------
sub commify {
    my $number = shift;
    1 while $number =~ s/^(-?\d+)(\d{3})/$1,$2/;
    return $number;
}

# ----------------------------------------------------
sub get_logger {
    my %opts      = ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $config    = Grm::Config->new;
    my $log_conf  = $config->get('logging');
    my $log_file  = $log_conf->{'log_file'} or croak 'No log file defined';
    my $log_level = $opts{'log_level'} || $log_conf->{'log_level'} || 'warn';

    my ( $pkg, $file, $line ) = caller;

    if ( -e $log_file && !-r _ ) {
        croak "Log file '$log_file' not writable";
    }

    my $logger = Log::Dispatch->new;
    $logger->add( 
        Log::Dispatch::File->new(
            name      => 'file',
            min_level => $log_level,
            filename  => $log_file,
            mode      => 'append',
            callbacks => sub { 
                my %p   = @_; 
                my $msg = $p{'message'};
                my $now = scalar localtime;
                chomp $msg;
                return "[$now] $file:$pkg:$line: $msg\n";
            },
        )
    );

    return $logger;
}

# ----------------------------------------------------
sub gramene_cdbi_class_to_module_name {
	my $class = shift or croak 'No DBIC class name';

    $class = ref $class if ref $class;
	
	my ($gramene, $cdbi, $module, $table) = split /::/, $class;
	
    $module =~ s/([A-Z])/_$1/g;
    $module =~ s/^_//;
	return lc $module;
}

# ----------------------------------------------------
sub gramene_cdbi_class_to_table_name {
	my $class = shift or croak 'No DBIC class name';

    $class = ref $class if ref $class;
	
	my ($gramene, $cdbi, $module, $table) = split /::/, $class;
	
	$table =~ s/([A-Z])/_\l$1/g;
	$table =~ s/^_//;

	return $table;
}

# ----------------------------------------------------
sub iterative_search_values {
    my $v       = shift || '';
    my $options = shift || {};

    my @return;

    if ( $v ) {
        push @return, $v;

        unless ( $v =~ /^\*.+\*$/ ) {
            push @return, "$v*" unless $v =~ /\*$/;
            push @return, "*$v*" unless $options->{'no_leading_wildcard'};
        }
    }
    else {
        @return = ('*');
    }

    return @return;
}

# ----------------------------------------------------
sub match_context {
    my ( $find, $s ) = @_;

    my $end_token               = chr( 6 );
    my $max_chars_match_context = 40;
    my $start_token             = chr( 7 );

    # Remove punctuation used for MySQL boolean/fulltext searches, spaces
    my @find 
        = map { s/^["(\s+-]+|[")\s]+$//g; quotemeta($_) } 
        split /\s+/, $find;

    my $t = $s;
    for my $f ( @find ) {
        $s =~ s/($f)/${start_token}${1}${end_token}/gi;
    }

    #
    # For very long strings (e.g., literature abstracts), this limits
    # to just the first seven hits;  if there are that many or more,
    # this much context should help the user understand that this is 
    # a good match.
    #
    my $pos         = -1;
    my $match_num   = 0;
    my $max_matches = 7;
    my $last_match  = 0;
    while ( ( $pos = index( $s, $end_token, $pos )) > -1 ) {
        $match_num++;
        $last_match = $pos;
        if ( $match_num == 7 ) {
            my $stop = index( $s, $end_token, $pos + 1 ) || $pos + 1;
            $s = substr( $s, 0, $stop + 25 );
        }
        else {
            $pos++;
        }
    }

    # 
    # Even if there weren't too many matches, the string may still
    # be too long, so truncate it after the last match.
    # 
    if ( $match_num < $max_matches && length($s) - $last_match > 50 ) {
        $s = substr( $s, 0, $last_match + 25 );
    }

    $s =~ s/^[^$start_token]+((?:\S+\s+){2}\S*$start_token)/...$1/xms;
    $s =~ s/
        ($end_token\S*)
        ((?:\s+\S+){3})
        .{$max_chars_match_context,}?
        ((?:\S+\s+){3})
        (\S*$start_token)
        /$1$2...<br\/>$3$4/gxms;

    $s =~ s/$start_token/<b><span class="matching">/g;
    $s =~ s/$end_token/<\/span><\/b>/g;

    return $s;
}

# ----------------------------------------------------
sub module_name_to_gdbic_class {
    my $module = shift or croak 'No module name';

    if ( $module =~ /^(ensembl|diversity|pathway)_/ ) {
        $module = $1;
    }

    my $class = join('::', 
        'Grm', 'DBIC', 
        join( '', map { ucfirst } split /_/, lc($module)),
    );

    return $class;
}

# ----------------------------------------------------
sub pager {
    if ( scalar(@_) % 2 ) {
        carp("odd number of args to pager");
    }

    my %args             =  @_;
    my $entries_per      =  $args{'entries_per_page'} || 25; 
    my $current_page     =  $args{'current_page'}     ||  1;
    my $url              =  $args{'url'}              || '';
       $url             .=  '?' unless $url =~ /\?/;
    my $data             =  $args{'data'};
    my $count            =  $args{'count'};
    my $object_name      =  $args{'object_name'} || 'Items';
    my $total            =  $count || scalar @{ $data || [] } || return;
    my $pager            =  Data::Pageset->new({
        total_entries    => $total,
        entries_per_page => $entries_per,
        current_page     => $current_page,
    });

    my $text = qq[<form method="get">&nbsp;&nbsp;$object_name ] . 
        commify( $pager->first ) .
        ' to ' . commify( $pager->last ) . 
        ' of ' . commify( $pager->total_entries );

    if ( $pager->last_page > 1 ) {
        $text .= '.' . '&nbsp;' x 15;
        $url  =~ s/[;&]?page_no=\d+//;          # get rid of page_no arg
        $url  =~ s!^http://.*?(?=/)!!;          # remove host
        (my $query_string = $url) =~ s/^.*\?//; # isolate the query string
        my $q =  CGI->new( $query_string );

        if ( my $prev = $pager->previous_page ) {
            $text .= $q->a( 
                { href=> "$url&page_no=${prev}" }, 'Previous' 
            ) . ' | ';
        }

        for my $param ( $q->param ) {
            next if $param eq 'page_no';
            for my $value ( $q->param( $param ) ) {
                $text .= qq[<input type="hidden" name="$param" value="$value">];
            }
        }

        $text .= '<input type="submit" value="Page">' .
            '<input name="page_no" size="4" value="' . 
            $pager->current_page . '">' . 
            ' of ' . commify($pager->last_page) . '.';

        if ( my $next = $pager->next_page ) {
            $text .= ' | ' . $q->a( 
                { href=> "$url&page_no=${next}" }, 'Next'
            );
        }
    }

    $text .= '&nbsp;&nbsp;</form>';
    $data  = [ $pager->splice( $data ) ] if @{ $data || [] };
    return wantarray ? ( $text, $data ) : $text;
}

# ----------------------------------------------------
sub parse_words {
    my $string    = shift;
    my @words     = ();
    my $inquote   = 0;
    my $length    = length($string);
    my $nextquote = 0;
    my $nextspace = 0;
    my $pos       = 0;

    # shrink whitespace sets to just a single space
    $string =~ s/\s+/ /g;

    # Extract words from list
    while ( $pos < $length ) {
        $nextquote = index( $string, '"', $pos );
        $nextspace = index( $string, ' ', $pos );
        $nextspace = $length if $nextspace < 0;
        $nextquote = $length if $nextquote < 0;

        if ( $inquote ) {
            push(@words, substr($string, $pos, $nextquote - $pos));
            $pos = $nextquote + 2;
            $inquote = 0;
        } 
        elsif ( $nextspace < $nextquote ) {  
            push @words,
                split /[,\s+]/, substr($string, $pos, $nextspace - $pos);
            $pos = $nextspace + 1;
        } 
        elsif ( $nextspace == $length && $nextquote == $length ) {
            # End of the line
            push @words, 
                map { s/^\s+|\s+$//g; $_ }
                split /,/,
                substr( $string, $pos, $nextspace - $pos );
            $pos = $nextspace; 
        }
        else {
            $inquote = 1;
            $pos = $nextquote + 1;
        }
    }

    push( @words, $string ) unless scalar( @words );

    return @words;
}

# ----------------------------------------------------
sub table_name_to_gdbic_class {
    if ( scalar @_ != 2 ) {
        croak 'table_name_to_gcdbi_class needs module and table name';
    }

    my $module     = shift or croak 'No module name';
    my $table_name = shift or croak 'No table name';
    my $class      = join('::', 
        'Grm', 'DBIC', 
        join( '', map { ucfirst } split /_/, lc($module)),
        join( '', map { ucfirst } split /_/, lc($table_name))
    );

    return $class;
}

1;

# ----------------------------------------------------

__END__

=pod

=head1 NAME

Grm::Utils - generalized utilities

=head1 SYNOPSIS

  use Grm::Utils qw( sub );

=head1 DESCRIPTION

This module contains general-purpose routines, all of which are
exported by default.

=head1 EXPORTED SUBROUTINES

=head2 commify

Turns "12345" into "12,345"

=head2 iterative_search_values

  for my $v ( 
      iterative_search_values( 'foo', { no_leading_wildcard => 1 } ) 
  ) {
      my @data = search( val => $v ) && last;
  );

Options:

  no_leading_wildcard - don't return a new value with "*" 
                        at the beginning

Aids searches by iteratively adding wildcards, e.g., for "foo" then
"foo*" then "*foo*."

=head2 get_logger

  my $logger = get_logger( log_level => 'debug' );
  $logger->info("Setting db to '$db_name'");

Returns a Log::Dispatch::File logger.

=head2 pager

Create a pager for data using Data::Pageset.

=head3 Arguments

=over 4

=item * data

An array reference of the dataset

=item * count

The number of records if "data" is not present

=item * url

The URL to use in constructing links

=item * current_page

Integer value of the current page number

=item * entries_per_page

Maximum number of records to allow many on a page; optional, default
value = 25.

=item * object_name

Use something like "Markers" instead of the (default) generic "Items"

=back

=head3 Returns

=over 4

=item * A string of HTML that is the pager navigator

=item * The current "page/slice" of data

=back

(In a scalar context, only returns the first.)

E.g.:

  my ( $pager, $data ) = pager(
      data             => $data, # or "count => 504"
      current_page     => $cgi->param('page_no'),
      url              => 'myscript.cgi?foo=bar&baz=quux',
      entries_per_page => 25,
      object_name      => 'Markers', # instead of default "Items"
  );
  $body .= "<center>$pager</center>";
  for my $rec ( @$data ) { ... }

=head2 parse_words

  "Foo bar" baz => ('Foo bar', 'baz')

Stole this from String::ParseWords::parse by Christian Gilmore
(CPAN ID: CGILMORE), modified to split on commas or spaces.  Allows
quoted phrases within a string to count as a "word," e.g.:

=head2 table_name_to_gdbic_class

  my $class = table_name_to_gcdbi_class( 'Markers', 'marker_type' );
  # $class now has "Grm::DBIC::Markers::MarkerType"

Turns a module's table name into it's Grm::DBIC class.  Both arguments
are required.

=head2 module_name_to_gdbic_class

  my $class = module_name_to_gdbic_class('germplasm');
  # $class now has "Grm::DBIC::Germplasm"

Turns a module's name into it's Grm::DBIC class. The module name is required

=head1 AUTHOR

Gramene Authors E<lt>gramene@gramene.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This library is free software;  you can redistribute it and/or modify 
it under the same terms as Perl itself.

=cut
