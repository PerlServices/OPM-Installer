package OTRS::OPM::Installer::Utils::File;

# ABSTRACT: File related utility functions

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef Str);
use OTRS::OPM::Installer::Types;
use OTRS::Repository;
use HTTP::Tiny;
use IO::All;
use OTRS::OPM::Installer::Logger;
use File::Spec;
use File::HomeDir;

has repositories => ( is => 'ro', isa => ArrayRef[Str], default => \&_repository_list );
has package      => ( is => 'ro', isa => Str, required => 1 );
has otrs_version => ( is => 'ro', isa => Str, required => 1 );
has logger       => ( is => 'ro', default => sub{ OTRS::OPM::Installer::Logger->new } );
has rc_config    => ( is => 'ro', lazy => 1, default => \&_rc_config );

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

sub _rc_config {
    my ($self) = @_;

    my $dot_file = File::Spec->catfile(
        File::HomeDir->my_home,
        '.opminstaller.rc'
    );

    my %config;
    if ( -e $dot_file && open my $fh, '<', $dot_file ) {
        while ( my $line = <$fh> ) {
            chomp $line;
            next if $line =~ m{\A\s*\#};
            next if $line =~ m{\A\s*\z};

            my ($key, $value) = split /\s*=\s*/, $line;
            $key = lc $key;

            if ( $key eq 'repository' ) {
                push @{ $config{$key} }, $value;
            }
            else {
                $config{$key} = $value;
            }
        }
    }

    return %config;
}

1;
