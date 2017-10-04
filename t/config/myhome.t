#!/usr/bin/env perl

use v5.10;

use strict;
use warnings;

use Test::More;
use File::Basename;

BEGIN {
    $ENV{HOME} = dirname(__FILE__);
};

use OTRS::OPM::Installer::Utils::Config;

my $obj = OTRS::OPM::Installer::Utils::Config->new;

isa_ok $obj, 'OTRS::OPM::Installer::Utils::Config';

my $config       = $obj->rc_config;
my $config_check = {
    otrs_path  => '/local/otrs',
    repository => [
        'file://hallo/test',
        'http://opar.perl-services.de/1234',
    ],
};

is_deeply $config, $config_check;

done_testing();
