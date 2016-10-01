package OTRS::OPM::Installer::Utils::Config;

# ABSTRACT: File related utility functions

use strict;
use warnings;

our $VERSION = 0.01;

use Moo;

has rc_config => ( is => 'ro', lazy => 1, default => \&_rc_config );

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

    return \%config;
}

1;
