package OTRS::OPM::Installer::Logger;

# ABSTRACT: A simple logger for OTRS::OPM::Installer

use strict;
use warnings;

use Moo;
use IO::All;
use File::Temp;
use Time::Piece;

my $file = File::Temp->new->filename;

has log  => ( is => 'ro', lazy => 1, default => sub { $file } );

for my $level (qw/notice info debug warn error/) {
    no strict 'refs';
    *{"OTRS::OPM::Installer::Logger::$level"} = sub {
        shift->print( $level, @_ );
    };
}

sub print {
    my ($self, $tag, %attr) = @_;

    my $attrs   = join " ", map{
        my $escaped = $attr{$_} // '';
        $escaped =~ s{\\}{\\\\}g;
        $escaped =~ s{"}{\\"}g;

        sprintf '%s="%s"', $_, $escaped
    }sort keys %attr;

    my $date    = localtime;
    my $message = sprintf "[%s] [%s %s] %s \n", uc $tag, $date->ymd, $date->hms, $attrs;
    $message >> io $self->log;
}

sub BUILD {
    my ($self, $param) = @_;

    if ( $param->{path} ) {
        $file = $param->{path};
    }

    my $date    = localtime;
    my $message = sprintf "[DEBUG] [%s %s] Start installation...\n", $date->ymd, $date->hms;

    $message > io $self->log
}
    
1;

=head1 SYNOPSIS

    use OTRS::OPM::Installer::Logger;
    
    my $logger = OTRS::OPM::Installer::Logger->new; # creates a new temporary file
    
    # or
    my $logger = OTRS::OPM::Installer::Logger->new(
        path => 'my_otrs_installer.log',
    );

    $logger->debug( message => 'message' );
    $logger->error( type => 'cpan', message => 'Cannot install module' );
    $logger->notice( message => 'test' );
    $logger->info( any_key => 'a value' );
    $logger->warn( module => 'test', text => 'a warning' );
