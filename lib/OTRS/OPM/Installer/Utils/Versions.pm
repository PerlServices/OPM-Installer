package OTRS::OPM::Installer::Utils::Versions;

use strict;
use warnings;

use Moo;

sub compare {
    my ($self,%params) = @_;

    my @version1 = split /\./, $params{version1};
    my @version2 = split /\./, $params{version2};

    my $limit;

    for ( 0 .. 2 ) {
        
    }
}

1;
