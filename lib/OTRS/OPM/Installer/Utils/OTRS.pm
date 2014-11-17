package OTRS::OPM::Installer::Utils::OTRS;

# ABSTRACT: class that provides helper functionality regarding the OTRS installation

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef Str);

use OTRS::OPM::Installer::Types qw(OTRSVersion);
use OTRS::OPM::Installer::Utils::Versions;

has otrs_version => ( is => 'rwp', lazy => 1, default => \&_find_version);#isa => OTRSVersion );
has inc          => ( is => 'rwp', lazy => 1, default => \&_build_inc );#isa => ArrayRef[Str] );
has path         => ( is => 'rwp', lazy => 1, default => \&_find_path );#isa => Str );
has manager      => ( is => 'rwp', lazy => 1, default => \&_build_manager );#isa => Object );
has db           => ( is => 'rwp', lazy => 1, default => \&_get_db );#isa => Object );

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

sub _find_version {
    my ($self) = @_;

    my $file    = $self->path . '/RELEASE';
    my $content = do { local ( @ARGV, $/ ) = $file; <> };

    my ($version) = $content =~ m{VERSION \s+ = \s+ ([0-9.]+)}xms;
    return $version;
}

sub _get_db {
    my ($self) = @_;

    return $self->
}

sub _build_inc {
    my ($self) = @_;

    return [ map{ $self->path . "/" . $_ }( '', 'cpan-lib' ) ];
}

sub _find_path {
    my ($self) = @_;
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
    };

    $manager;
}

sub BUILD {
}

1;
