#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use File::Basename;
use Getopt::Long;
use Grm::Utils qw( table_name_to_gdbic_class );
use Pod::Usage;
use Readonly;

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

if ( scalar @ARGV != 2 ) {
    pod2usage('Provide module and table name');
}

my ( $module, $table ) = @ARGV;

my $class = table_name_to_gdbic_class( $module, $table );

print "$class\n";

#$class->new();

my $db     = Grm::DB->new('maps');
my $schema = Grm::DBIC::Maps->connect(;



__END__

# ----------------------------------------------------

=pod

=head1 NAME

check-table.pl - a script

=head1 SYNOPSIS

  check-table.pl module table

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

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
