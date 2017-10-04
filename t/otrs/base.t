#!/usr/bin/env perl

use v5.10;

use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

BEGIN {
    $ENV{HOME} = File::Spec->catdir( dirname(__FILE__) );
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

my $otrs_dir =  File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__), 'opt' ) );
is $test->path, $otrs_dir;

is $test->obj_env, 'OTRS::OPM::Installer::Utils::OTRS::OTRS4';
is $test->otrs_version, '5.0.8';

is_deeply $test->inc, [
    $otrs_dir,
    File::Spec->catdir( $otrs_dir, 'Kernel', 'cpan-lib' ),
];

is $test->manager, '';
is $test->db, '';

done_testing();
