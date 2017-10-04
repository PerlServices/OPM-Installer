package OTRS::OPM::Installer::Logger;

use strict;
use warnings;

use Moo;
use IO::All;
use File::Temp;
use Time::Piece;

our $VERSION = 0.01;

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
        my $escaped = $attr{$_};
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

