package OTRS::OPM::Installer::Utils::File;

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef Str);
use OTRS::OPM::Installer::Types;
use OTRS::Repository;
use HTTP::Tiny;
use File::Temp;

has repositories => ( is => 'ro', isa => ArrayRef[Str], default => \&_repository_list );
has package      => ( is => 'ro', isa => Str, required => 1 );
has otrs_version => ( is => 'ro', isa => Str, required => 1 );

sub resolve_path {
    my ($self) = @_;

    my $path;

    my $package = $self->package;
    if ( _is_url( $package ) ) {
        # download file
    }
    elsif ( -e $package ) {
        # do nothing, file already exists
        $path = $package;
    }
    else {
        my $repo = OTRS::Repository->new(
            sources => $self->_repository_for( $
        );
    }

    return $path;
}

sub _repository_list {
}

1;
