[![Kwalitee status](https://cpants.cpanauthors.org/dist/OPM-Installer.png)](https://cpants.cpanauthors.org/dist/OPM-Installer)
[![GitHub issues](https://img.shields.io/github/issues/perlservices/OPM-Installer.svg)](https://github.com/perlservices/OPM-Installer/issues)
[![CPAN Cover Status](https://cpancoverbadge.perl-services.de/OPM-Installer-1.0.0)](https://cpancoverbadge.perl-services.de/OPM-Installer-1.0.0)
[![Cpan license](https://img.shields.io/cpan/l/OPM-Installer.svg)](https://metacpan.org/release/OPM-Installer)

# NAME

OPM::Installer - Install ticketsystem (Znuny/OTOBO) add ons

# VERSION

version 1.0.0

# SYNOPSIS

```perl
use OPM::Installer;

my $installer = OPM::Installer->new;
$installer->install( 'FAQ' );

# or

my $installer = OPM::Installer->new();
$installer->install( package => 'FAQ', version => '2.1.9' );

# provide path to a config file
my $installer = OPM::Installer->new(
    conf => 'test.rc',
);
$installer->install( 'FAQ' );
```

# DESCRIPTION

This is an alternate installer for Znuny/OTOBO addons. The standard package manager
currently does not install dependencies. OPM::Installer takes care of those
dependencies and it can handle dependencies from different places.

# CONFIGURATION FILE

You can provide some basic configuration in a `.opminstaller.rc` file:

```
repository=http://ftp.addon.org/pub/addon/packages
repository=http://ftp.addon.org/pub/addon/itsm/packages33
repository=http://opar.perl-services.de
repository=http://feature-addons.de/repo
path=/opt/otrs
```

# ATTRIBUTES

- conf
- force
- has
- logger
- manager
- package
- prove
- repositories
- sudo
- utils\_ts
- verbose
- version

# ACKNOWLEDGEMENT

The development of this package was sponsored by https://feature-addons.de

# METHODS

## install

## list\_available



# Development

The distribution is contained in a Git repository, so simply clone the
repository

```
$ git clone git://github.com/perlservices/OPM-Installer.git
```

and change into the newly-created directory.

```
$ cd OPM-Installer
```

The project uses [`Dist::Zilla`](https://metacpan.org/pod/Dist::Zilla) to
build the distribution, hence this will need to be installed before
continuing:

```
$ cpanm Dist::Zilla
```

To install the required prequisite packages, run the following set of
commands:

```
$ dzil authordeps --missing | cpanm
$ dzil listdeps --author --missing | cpanm
```

The distribution can be tested like so:

```
$ dzil test
```

To run the full set of tests (including author and release-process tests),
add the `--author` and `--release` options:

```
$ dzil test --author --release
```

# AUTHOR

Renee Baecker <reneeb@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Renee Baecker.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
