package OPM::Installer::Utils::Test;

# ABSTRACT: helper functions for Unittests

use strict;
use warnings;

# VERSION

use Moo::Role;
use File::Spec;
use File::Basename;

sub _find_path {
    my ($self) = @_;

    my @levels_up = ('..') x 5;
    my $dir       = File::Spec->catdir( dirname(__FILE__), @levels_up );
    my $testdir   = File::Spec->catdir( $dir, $ENV{OPMINSTALLERTEST} );

    if ( !-d $testdir ) {
        $testdir = File::Spec->catdir( $dir, 3 );
    }

    return $testdir;
}

1;

