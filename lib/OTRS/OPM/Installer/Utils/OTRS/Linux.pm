package OTRS::OPM::Installer::Utils::OTRS::Linux;

use strict;
use warnings;

use Moo::Role;

use File::Spec;
use File::Basename;
use List::Util qw(first);
use File::Glob qw(bsd_glob);

sub _find_path {
    my ($self) = @_;

    my @checks    = qw(/opt/otrs /srv/otrs /etc/otrs);
    my ($testdir) = grep { -d $_ }@checks;

    return $testdir if $testdir;

    # try to find apache installation and read from config
    my ($apachedir) = grep{ -d $_ }qw(/etc/apache2 /etc/httpd);
    return if !$apachedir;

    
}

1;
