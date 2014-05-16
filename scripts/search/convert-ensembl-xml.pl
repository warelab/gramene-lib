#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Data::Dump 'dump';
use File::Basename 'basename';
use File::Path 'mkpath';
use File::Spec::Functions;
use List::MoreUtils 'uniq';
use Getopt::Long;
use Grm::Utils qw( commify timer_calc );
use HTML::Entities 'decode_entities';
use Pod::Usage;
use Readonly;
use XML::Simple 'XMLin';

Readonly my $RS => chr(30);
Readonly my $FS => chr(31);

Readonly my %SKIP_FIELD = map { $_, 1 } qw( 
    database databse domain_count exon_count genomic_unit haplotype location
    source system_name species transcript_count featuretype
);

Readonly my %SKIP_XREF = map { $_, 1 } qw( 
    ENA_FEATURE_PROTEIN ENA_FEATURE_TRANSCRIPT ENA_FEATURE_GENE
);

my $out_dir = cwd();
my ( $help, $man_page );
GetOptions(
    'd|dir:s' => \$out_dir,
    'help'    => \$help,
    'man'     => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my @files = @ARGV or pod2usage('No input files');
my $num_files = scalar @files;

printf "Will export %s file%s to '%s'\n", 
   $num_files, 
   $num_files == 1 ? '' : 's',
   $out_dir,
;

my $file_num   = 0;
my $total_time = timer_calc();
FILE:
for my $file (@files) {
    my $timer = timer_calc();

    printf "%3d/%3d: %s\n", ++$file_num, $num_files, basename($file);

    my $xml  = XMLin($file);
    my $name = $xml->{'name'} or next FILE;

    my $species;
    if ($name =~ /^([a-z_]+)_core_.*/) {
        $species = $1;
    }
    else {
        say "$name doesn't look like a core, skipping.";
        next FILE;
    }

    my $module   = 'ensembl_' . $species;
    my $out_file = $name . '.adt';

    my @entries = values %{ $xml->{'entries'}{'entry'} || {} };
    my $num_entries = scalar @entries;

    if ( !$num_entries ) {
        print "No entries!\n";
        next FILE;
    }

    printf "%s entries => %s\n", commify($num_entries), basename($out_file);

    my $out_path = catfile($out_dir, $out_file);
    open my $out_fh, '>', $out_path;
    print $out_fh join($FS,
        qw[id title module object species taxonomy content]
    ), $RS;

    for my $entry (@entries) {
        my $name = $entry->{'name'} || $entry->{'id'};

        next unless $name;

        my $desc = '';
        if ( $entry->{'description'} && !ref $entry->{'description'} ) {
            $desc = $entry->{'description'};
        }

        my $title = sprintf('%s%s', 
            $name, 
            $desc ? ' (' . $desc . ')' : '',
        );

        my $object = 
          lc $entry->{'additional_fields'}{'field'}{'featuretype'}{'content'} 
          || 'gene';

        (my $entry_species = 
          lc $entry->{'additional_fields'}{'field'}{'species'}{'content'} ||
          lc $entry->{'additional_fields'}{'field'}{'system_name'}{'content'} 
          || $species
        ) =~ s/ /_/g;

        my @content = ();
        while ( my ($key, $val) 
            = each %{ $entry->{'additional_fields'}{'field'} }
        ) {
            if (!$SKIP_FIELD{$key} && defined $val->{'content'}) {
                push @content, $val->{'content'};
            }
        }

        my $ncbi_taxon_id = '';
        if (ref $entry->{'cross_references'}{'ref'} eq 'ARRAY') {
            for my $xref ( @{ $entry->{'cross_references'}{'ref'} } ) {
                if (
                    !$SKIP_XREF{$xref->{'dbname'}} && defined $xref->{'dbkey'}
                ) {
                    push @content, $xref->{'dbkey'};
                }

                if (
                    $xref->{'dbname'} eq 'ncbi_taxonomy_id' && $xref->{'dbkey'}
                ) {
                    $ncbi_taxon_id = $xref->{'dbkey'};
                }
            }
        }

        print $out_fh join($FS,
            map { clean($_) }
            join('/', $module, $object, $entry->{'id'}),
            $title,
            $module,
            $object,
            $species, 
            $ncbi_taxon_id,
            join(' ', map { defined $_ && $_ ? clean($_) : () } uniq(@content)),
        ), $RS;
    }

    close $out_fh;

    printf "Finished in %s\n", $timer->();
}

printf "Done processing %s file%s in %s\n",
    $file_num,
    $file_num == 1 ? 's' : '',
    $total_time->(),
;

# ----------------------------------------------------
sub clean {
    my $s = shift || '';

    $s =~ s/[^[:ascii:]]//g; # all non-ASCII text
    $s =~ s/[\n\r]//g;       # no CR/LF
    $s =~ s/["']//g;         # kill quotes
    $s =~ s/(\.\d+)\b//g;    # kill ".1" suffixes
    $s =~ s/^\s+|\s+$//g;    # trim
    $s =~ s/\s+/ /g;         # squish spaces
    $s = decode_entities($s);

    return $s;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

convert-ensembl-xml.pl - converts the XML dumped by Ensembl to a tab file

=head1 SYNOPSIS

  convert-ensembl-xml.pl 

Options:

  -d|--dir  Output directory (default cwd)
  --help    Show brief help and exit
  --man     Show full documentation

=head1 DESCRIPTION

Use this:

  https://github.com/EnsemblGenomes/eg-web-common/blob/master/utils/search_dump.pl 

To export the Ensembl dbs.  Then put into Solr format with this.

=head1 SEE ALSO

perl.

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
