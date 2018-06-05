package OTRS::OPM::Installer::Utils::File;

# ABSTRACT: File related utility functions

use v5.10;

use strict;
use warnings;

use File::HomeDir;
use File::Spec;
use File::Temp;
use HTTP::Tiny;
use HTTP::Tiny::FileProtocol;
use IO::All;
use Moo;
use OTRS::OPM::Installer::Logger;
use OTRS::OPM::Installer::Utils::Config;
use OTRS::OPM::Installer::Types;
use OTRS::Repository;
use Regexp::Common qw(URI);
use Types::Standard qw(ArrayRef Str Bool);

our $ALLOWED_SCHEME = [ 'HTTP', 'file' ];

has repositories => ( is => 'ro', isa => ArrayRef[Str], default => \&_repository_list );
has package      => ( is => 'ro', isa => Str, required => 1 );
has otrs_version => ( is => 'ro', isa => Str, required => 1 );
has version      => ( is => 'ro', isa => Str  );
has verbose      => ( is => 'ro', isa => Bool  );
has logger       => ( is => 'ro', default => sub{ OTRS::OPM::Installer::Logger->new } );
has rc_config    => ( is => 'ro', lazy => 1, default => \&_rc_config );
has conf         => ( is => 'ro' );

sub list_available {
    my $self = shift;

   my @repositories = @{ $self->repositories || [] };

   for my $repo_url ( @repositories ) {
       $repo_url .= '/otrs.xml' if '/otrs.xml' ne substr $repo_url, -9;
   }

   my $repo = OTRS::Repository->new(
       sources => \@repositories,
   );

   my $otrs_version = $self->otrs_version;
   $otrs_version    =~ s{\.\d+$}{};

   return $repo->list(
       otrs    => $otrs_version,
       details => 1,
   );
}

sub resolve_path {
    my ($self) = @_;

    my $path;

    my $package = $self->package;
    if ( $self->_is_url( $package ) ) {
        # download file
        $path = $self->_download( $package );
    }
    elsif ( -f $package ) {
        # do nothing, file already exists
        $path = $package;
    }
    else {
        my @repositories = @{ $self->repositories || [] };

        for my $repo ( @repositories ) {
            $repo .= '/otrs.xml' if '/otrs.xml' ne substr $repo, -9;
        }

        say "Searching these repositories: @repositories" if $self->verbose;

        my $repo = OTRS::Repository->new(
            sources => \@repositories,
        );

        my ($otrs) = $self->otrs_version =~ m{\A(\d+\.\d+)};

        my ($url) = $repo->find(
            name    => $package,
            otrs    => $otrs,
            version => $self->version,
        );

        say "Found ", $url // '<nothing>' if $self->verbose;

        return if !$url;

        $path = $self->_download( $url );
    }

    return $path;
}

sub _repository_list {
    my ($self) = @_;

    my $config       = $self->rc_config;
    my $repositories = $config->{repository};

    return [] if !$repositories;
    return $repositories;        
}

sub _is_url {
    my ($self, $package) = @_;

    my @allowed_schemes = ref $ALLOWED_SCHEME ? @{ $ALLOWED_SCHEME } : $ALLOWED_SCHEME;

    my $matches;

    SCHEME:
    for my $scheme ( @allowed_schemes ) {
        my $regex = ( lc $scheme eq 'http' ) ?
            $RE{URI}{HTTP}{-scheme => qr/https?/} :
            $RE{URI}{$scheme};

        if ( $package =~ m{\A$regex\z} ) {
            $matches++;
            last SCHEME;
        }
    }

    return if !$matches;
    return 1;
}

sub _download {
    my ($self, $url) = @_;

    my $file     = File::Temp->new->filename;
    my $response = HTTP::Tiny->new->mirror( $url, $file );

    $self->logger->notice( area => 'download', file => $file, success => $response->{success} );

    return if !$response->{success};
    return $file;
}

sub _rc_config {
    my ($self) = @_;

    my $utils  = OTRS::OPM::Installer::Utils::Config->new( conf => $self->conf );
    my $config = $utils->rc_config;

    return $config;
}

1;
