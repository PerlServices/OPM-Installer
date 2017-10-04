#!/usr/bin/env perl

use v5.10;

use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

BEGIN {
    $ENV{HOME} = File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__) ) );
}

use OTRS::OPM::Installer::Utils::OTRS;

$ENV{OTRSOPMINSTALLERTEST} = 'opt';

my $test = OTRS::OPM::Installer::Utils::OTRS->new( path => File::Spec->catdir( $ENV{HOME}, 'otrs3' ) );
isa_ok $test, 'OTRS::OPM::Installer::Utils::OTRS';
is $test->os_env, 'OTRS::OPM::Installer::Utils::OTRS::Test';

my $otrs_dir =  File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__), 'otrs3' ) );
is $test->path, $otrs_dir;

is $test->obj_env, 'OTRS::OPM::Installer::Utils::OTRS::OTRS3';
is $test->otrs_version, '3.3.12';

done_testing();
