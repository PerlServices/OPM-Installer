package OTRS::OPM::Installer::Utils::OTRS::OTRS4;

use strict;
use warnings;

use Moo::Role;

sub _get_db {
    my ($self) = @_;

    push @INC, @{ $self->inc };

    my $object;
    eval {
        require Kernel::ObjectManager;
        $object = $Kernel::OM->Get('Kernel::System::DB');
    };

    $object;
}

sub _build_manager {
    my ($self) = @_;

    push @INC, @{ $self->inc };

    my $manager;
    eval {
        require Kernel::ObjectManager;
        $manager = $Kernel::OM->Get('Kernel::System::Package');
    };

    $manager;
}

1;
