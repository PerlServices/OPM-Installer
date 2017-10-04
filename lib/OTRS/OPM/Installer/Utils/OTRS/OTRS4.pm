package OTRS::OPM::Installer::Utils::OTRS::OTRS4;

# ABSTRACT: helper functions for OTRS4 (and higher)

use strict;
use warnings;

sub _get_db {
    my ($self) = @_;

    push @INC, @{ $self->inc };

    my $object;
    eval {
        require Kernel::System::ObjectManager;
        $Kernel::OM = Kernel::System::ObjectManager->new;

        $object = $Kernel::OM->Get('Kernel::System::DB');
    } or die $@;

    $object;
}

sub _build_manager {
    my ($self) = @_;

    push @INC, @{ $self->inc };

    my $manager;
    eval {
        require Kernel::System::ObjectManager;
        $Kernel::OM = Kernel::System::ObjectManager->new;

        $manager = $Kernel::OM->Get('Kernel::System::Package');
    } or die $@;

    $manager;
}

1;
