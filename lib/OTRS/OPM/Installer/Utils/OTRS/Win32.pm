package OTRS::OPM::Installer::Utils::OTRS::Win32;

# ABSTRACT: Find OTRS installation on Win32 systems

use strict;
use warnings;

use Moo::Role;
use File::Spec;
use File::Basename;

sub _find_path {
    my ($self) = @_;

    my @dirs = ('C:\OTRS\OTRS', 'C:\Programme\OTRS', 'C:\Program Files');

}

1;
