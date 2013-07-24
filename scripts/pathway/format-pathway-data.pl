#!/usr/bin/env perl

=head1 NAME

format-pathway-data.pl

=cut

=head1 SYNOPSIS

 format-pathway-data.pl -d /path/to/pathway/file -o data.tab

Options:

  -d|--data     Path to the "data" directory of the Cyc db
  -o|--out      Where to place the output
  --help        Show brief help and exit
  --man         Show full documentation

=head1 DESCRIPTION

Formats the pathways data into a tab-delimited file to be imported into 
MySQL for indexing by the quick search.

Cf. http://gwiki.gramene.org/Pathway_database_for_gramene_search

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.eduE<gt>.

=cut

use strict;
use warnings;
use autodie;
use Getopt::Long;
use File::Spec::Functions;
use File::Path;
use Pod::Usage;

my $path     = '';
my $out_file = '';
my $help     = 0;
my $man      = 0;

GetOptions(
    'o|out=s'  => \$out_file,
    'd|data=s' => \$path,
    'help|?'   => \$help,
    'man'      => \$man,
) or pod2usage( 1 );

pod2usage( -verbose => 2 ) if $man;
pod2usage( 1 ) if $help;
$path     or pod2usage('No data path');
$out_file or pod2usage('No out file');

if ( !-e $out_file && -s _ ) {
    print "Out file '$out_file' exists\n";
    exit;
}

my $pwy_file      = catfile( $path, 'pathways.dat'  );
my $reaction_file = catfile( $path, 'reactions.dat' );
my $enzrxn_file   = catfile( $path, 'enzrxns.dat'   );
my $protein_file  = catfile( $path, 'proteins.dat'  );
my $gene_file     = catfile( $path, 'genes.dat'     );

my %pwys;

my ( $pwy, $name, @rxns );
open my $pwy_fh, '<', $pwy_file;
while ( <$pwy_fh> ) {
    chomp;
    next if /^#/;
    if ( /^UNIQUE-ID - (.+)/ ) {
        $pwy = $1;
    }
    elsif ( /^COMMON-NAME - (.+)/ ) {
        $name = $1;
    }
    elsif ( /^REACTION-LIST - (.+)/ ) {
        push @rxns, $1;
    }
    elsif ( /^\/\// ) {
        my @new_rxns = @rxns;
        $pwys{ $pwy }{'name'}      = $name;
        $pwys{ $pwy }{'reactions'} = \@new_rxns;
        $pwy = $name = '';
        @rxns = ();
    }
}
close $pwy_fh;

my %rxns;
my ( $rxn, $ec, $rxn_name, @enzs );
open my $rxn_fh, '<', $reaction_file;
while ( <$rxn_fh> ) {
    chomp;
    next if /^#/;
    if ( /^UNIQUE-ID - (.+)/ ) {
        $rxn = $1;
    }
    elsif ( /^COMMON-NAME - (.+)/ ) {
        $rxn_name = $1;
    }
    elsif ( /^EC-NUMBER - (.+)/ ) {
        $ec = $1;
    }
    elsif ( /^ENZYMATIC-REACTION - (.+)/ ) {
        push @enzs, $1;
    }
    elsif ( /^\/\// ) {
        my @new_enzs = @enzs;
        $rxns{ $rxn }{'name'}    = $rxn_name;
        $rxns{ $rxn }{'ec'}      = $ec;
        $rxns{ $rxn }{'enzymes'} = \@new_enzs;
        $rxn = $rxn_name = '';
        @enzs = ();
    }
}
close $rxn_fh;

my %enzrxns;
my ( $enz, $enz_name, $protein_id );
open my $enz_fh, '<', $enzrxn_file;
while ( <$enz_fh> ) {
    chomp;
    next if /^#/;
    if ( /^UNIQUE-ID - (.+)/ ) {
        $enz = $1;
    }
    elsif ( /^COMMON-NAME - (.+)/ ) {
        $enz_name = $1;
    }
    elsif ( /^ENZYME - (.+)/ ) {
        $protein_id = $1;
    }
    elsif ( /^\/\// ) {
        $enzrxns{ $enz }{'name'}   = $enz_name;
        $enzrxns{ $enz }{'enzyme'} = $protein_id;
        $enz = $enz_name = $protein_id = '';
    }
}
close $enz_fh;

my %proteins;
my ( $protein, $type, $gene, @components );
open my $protein_fh, '<', $protein_file;
while ( <$protein_fh> ) {
    chomp;
    next if /^#/;
    if ( /^UNIQUE-ID - (.+)/ ) {
        $protein = $1;
    }
    elsif ( /^TYPES - (.+)/ ) {
        $type = $1;
    }
    elsif ( /^COMPONENTS - (.+)/ ) {
        push @components, $1;
    }
    elsif ( /^GENE - (.+)/ ) {
        $gene = $1;
    }
    elsif ( /^\/\// ) {
        $proteins{ $protein }{'gene'}  = $gene;
        $proteins{ $protein }{'types'} = $type;
        my @new_components = @components;
        $proteins{ $protein }{'components'} = \@new_components;
        $protein = $type = $gene = '';
        @components = ();
    }
}
close $protein_fh;

my %genes;
open my $gene_fh, '<', $gene_file;
while ( <$gene_fh> ) {
    chomp;
    next if /^#/;
    if ( /^UNIQUE-ID - (.+)/ ) {
        $gene = $1;
    }
    elsif ( /^TYPES - (.+)/ ) {
        $type = $1;
    }
    elsif ( /^\/\// ) {
        $genes{ $gene } = 1;
        $gene = $type = '';
    }
}
close $gene_fh;

my %gene_pwys;
open my ($out_fh), '>', $out_file;

for my $pwy ( keys %pwys ) {
    my $reaction_list = $pwys{ $pwy }{'reactions'};
    for my $rxn ( @$reaction_list ) {
        my $rxnenzs = $rxns{$rxn}->{'enzymes'};
        if ( $rxnenzs && scalar( @$rxnenzs ) > 0 ) {
            for my $rxnenz ( @$rxnenzs ) {
                my $enz  = $enzrxns{ $rxnenz }{'enzyme'};
                my $gene = $proteins{$enz}->{'gene'};
                if ( $gene ) {
                    $gene_pwys{ $gene }{ $rxnenz }{ $rxn }{ $pwy } = 1;
                }
                else {
                    print "gene not found for $enz\n";
                }
            }
        }
    }

}

print $out_fh join(
    "\t",
    qw(
        gene_name
        enzyme_name
        reaction_id
        reaction_name
        ec
        pathway_id
        pathway_name
    )
), "\n";

for my $gene ( keys %gene_pwys ) {
    my $rxnenzs2 = $gene_pwys{$gene};
    for my $rxnenz ( keys %$rxnenzs2 ) {
        my $rxns2    = $rxnenzs2->{ $rxnenz };
        my $enz_name = $enzrxns{ $rxnenz }{'name'};
        for my $rxn ( keys %$rxns2 ) {
            my $pwys2    = $rxns2->{ $rxn };
            my $rxn_name = $rxns{ $rxn }{'name'};
            my $ec       = $rxns{ $rxn }{'ec'};
            for my $pwy ( keys %$pwys2 ) {
                my $pwy_name = $pwys{ $pwy }{'name'};
                print $out_fh join(
                    "\t",
                    map { defined $_ ? $_ : '' } (
                        $gene, $enz_name, $rxn, $rxn_name,
                        $ec,   $pwy,      $pwy_name
                    )
                ), "\n";
            }
        }
    }
}

close $out_fh;

print "Done\n";
