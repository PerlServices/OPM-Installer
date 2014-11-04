package OTRS::OPM::Installer::Utils::File;

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef Str);
use OTRS::OPM::Installer::Types;
use OTRS::Repository;
use HTTP::Tiny;
use IO::All;
use OTRS::OPM::Installer::Logger;

has repositories => ( is => 'ro', isa => ArrayRef[Str], default => \&_repository_list );
has package      => ( is => 'ro', isa => Str, required => 1 );
has otrs_version => ( is => 'ro', isa => Str, required => 1 );
has logger       => ( is => 'ro', default => sub{ OTRS::OPM::Installer::Logger->new } );

sub resolve_path {
    my ($self) = @_;

    my $path;

    my $package = $self->package;
    if ( $self->_is_url( $package ) ) {
        # download file
        $path = $self->_download( $package );
    }
    elsif ( -e $package ) {
        # do nothing, file already exists
        $path = $package;
    }
    else {
        my $repo = OTRS::Repository->new(
            sources => $self->_repository_for( $self->otrs_version ),
        );

        my ($url) = $repo->find( );
        $path = $self->_download( $package );
    }

    return $path;
}

sub _repository_list {
}

sub _is_download {
}

sub _download {
    my ($self, $url) = @_;

    my $file     = io '?';
    my $response = HTTP::Tiny->new->mirror( $url, $file );

    $self->logger->notice( area => 'download', file => $file, success => $response->{success} );

    return $file;
}

1;
