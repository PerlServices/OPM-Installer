package OTRS::OPM::Installer::Utils::Config;

# ABSTRACT: File related utility functions

use strict;
use warnings;

our $VERSION = 0.03;

use Carp qw(croak);
use File::Basename;
use File::HomeDir;
use File::Spec;
use Moo;

has rc_config => ( is => 'ro', lazy => 1, default => \&_rc_config );
has conf      => ( is => 'ro' );

sub _rc_config {
    my ($self) = @_;

    my $dot_file = File::Spec->catfile(
        File::HomeDir->my_home,
        '.opminstaller.rc'
    );

    if ( $self->conf && -f $self->conf ) {
        $dot_file = $self->conf;
    }
    elsif ( $self->conf ) {
        croak 'Config file ' . $self->conf . ' does not exist';
    }

    my %config;
    if ( -f $dot_file && open my $fh, '<', $dot_file ) {
        while ( my $line = <$fh> ) {
            chomp $line;
            next if $line =~ m{\A\s*\#};
            next if $line =~ m{\A\s*\z};

            my ($key, $value) = split /\s*=\s*/, $line;
            $key = lc $key;

            if ( $key eq 'repository' ) {
                push @{ $config{$key} }, $value;
            }
            elsif ( $key eq 'otrs_path' ) {
                if ( !File::Spec->file_name_is_absolute( $value ) ) {
                    my $dir = dirname $dot_file;
                    $value = File::Spec->rel2abs(
                        File::Spec->catdir( $dir, $value ),
                    );
                }

                $config{$key} = $value;
            }
            else {
                $config{$key} = $value;
            }
        }
    }

    return \%config;
}

1;
