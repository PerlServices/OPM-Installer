package OTRS::OPM::Installer::Utils::OTRS;

# ABSTRACT: class that provides helper functionality regarding the OTRS installation

use strict;
use warnings;

use Carp;
use Moo;
use Types::Standard qw(ArrayRef Str);

use OTRS::OPM::Installer::Types qw(OTRSVersion);
use OTRS::OPM::Installer::Utils::File;

has otrs_version => ( is => 'rwp', lazy => 1, default => \&_find_version);#isa => OTRSVersion );
has inc          => ( is => 'rwp', lazy => 1, default => \&_build_inc );#isa => ArrayRef[Str] );
has path         => ( is => 'rwp', lazy => 1, default => \&_find_path );#isa => Str );
has manager      => ( is => 'rwp', lazy => 1, default => \&_build_manager );#isa => Object );
has db           => ( is => 'rwp', lazy => 1, default => \&_get_db );#isa => Object );

sub is_installed {
    my ($self, %param) = @_;

    my $sql = 'SELECT name, version FROM package_repository WHERE name = ?';

    return if !$self->db;

    $self->db->Prepare(
        SQL  => $sql,
        Bind => [ \$param{package} ],
    );

    my %info;
    while ( my @row = $self->db->FetchrowArray() ) {
        %info = (
        );
    }

    return %info;
}

sub _find_version {
    my ($self) = @_;

    my $file    = $self->path . '/RELEASE';
    my $content = do { local ( @ARGV, $/ ) = $file; <> };

    my ($version) = $content =~ m{VERSION \s+ = \s+ ([0-9.]+)}xms;
    return $version;
}

sub _build_inc {
    my ($self) = @_;

    return [ map{ $self->path . "/" . $_ }( '', 'cpan-lib' ) ];
}

sub BUILDARGS {
    my $class = shift;

    if ( @_ % 2 != 0 ) {
        croak 'Check the parameters for ' . __PACKAGE__ . '. You have to pass a hash.';
    }

    my %args = @_;
    if ( !exists $args{path} ) {
        my $utils = OTRS::OPM::Installer::Utils::File->new;
        my $cfg   = $utils->rc_conf;

        $args{path} = $cfg{otrs_path} if defined $cfg{otrs_path};
    }
}

sub BUILD {
    my ($self) = @_;

    my ($major) = $self->otrs_version =~ m{\A(\d+)\.};
    if ( $major <= 3 ) {
        with 'OTRS::OPM::Installer::Utils::OTRS::OTRS3';
    }
    else {
        with 'OTRS::OPM::Installer::Utils::OTRS::OTRS4';
    }

    if ( $ENV{OTRSOPMINSTALLERTEST} ) {
        with 'OTRS::OPM::Installer::Utils::OTRS::Test';
    }
    elsif ( $^O =~ m{Win32}i ) {
        with 'OTRS::OPM::Installer::Utils::OTRS::Win32';
    }
    else {
        with 'OTRS::OPM::Installer::Utils::OTRS::Linux';
    }
}

1;
