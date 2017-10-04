package OTRS::OPM::Installer::Utils::OTRS::OTRS3;

# ABSTRACT: helper functions for OTRS3

use strict;
use warnings;

sub _get_db {
    my ($self) = @_;

    return $self->manager->{DBObject};
}

sub _build_manager {
    my ($self) = @_;

    push @INC, @{ $self->inc };

    my $manager;
    eval {
        require Kernel::Config;
        require Kernel::System::Main;
        require Kernel::System::Encode;
        require Kernel::System::Log;
        require Kernel::System::DB;
        require Kernel::System::Time;
        require Kernel::System::Package;

        my %objects = ( ConfigObject => Kernel::Config->new );

        for my $module (qw/Main Encode Log DB Time Package/) {
            my $class = 'Kernel::System::' . $module;
            $objects{$module . 'Object'} = $class->new( %objects );
        }

       $manager = $objects{PackageObject};
    } or die $@;

    $manager;
}

1;
