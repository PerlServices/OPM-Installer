#!/usr/bin/env perl

use v5.10;

use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

BEGIN {
    $ENV{HOME} = File::Spec->catdir( dirname(__FILE__), 'opt' );
}

use OTRS::OPM::Installer::Utils::OTRS;

diag "Testing *::OTRS version " . OTRS::OPM::Installer::Utils::OTRS->VERSION();

my $linux = OTRS::OPM::Installer::Utils::OTRS->new;
isa_ok $linux, 'OTRS::OPM::Installer::Utils::OTRS';
is $linux->os_env, 'OTRS::OPM::Installer::Utils::OTRS::Linux';

$ENV{OTRSOPMINSTALLERTEST} = 'opt';

my $test = OTRS::OPM::Installer::Utils::OTRS->new;
isa_ok $test, 'OTRS::OPM::Installer::Utils::OTRS';
is $test->os_env, 'OTRS::OPM::Installer::Utils::OTRS::Test';

done_testing();
