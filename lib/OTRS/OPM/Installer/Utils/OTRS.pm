package OTRS::OPM::Installer::Utils::OTRS;

# ABSTRACT: class that provides helper functionality regarding the OTRS installation

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef Str);

use OTRS::OPM::Installer::Types qw(OTRSVersion);
use OTRS::OPM::Installer::Utils::Versions;

has otrs_version => ( is => 'rwp', );#isa => OTRSVersion );
has inc          => ( is => 'rwp', );#isa => ArrayRef[Str] );
has path         => ( is => 'rwp', );#isa => Str );
has manager      => ( is => 'rwp', );#isa => Object );
has db           => ( is => 'rwp', );#isa => Object );

sub is_installed {
    my ($self) = @_;

    my $sql = 'SELECT name, version FROM package_repository WHERE name = $param{package}';

    return if !$self->db;

    $self->db->Prepare(
    );

    my $name;
    while ( my @row = $self->db->FetchrowArray() ) {
    }
}

sub _build_manager {
}

sub BUILD {
}

1;
