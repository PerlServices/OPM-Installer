package OTRS::OPM::Installer::Logger;

use strict;
use warnings;

use Moo;
use IO::All -utf8;

our $VERSION = 0.01;

my $file = io '?';

has log => (is => 'ro', default => sub { $file });

for my $level (qw/notice info debug warn error/) {
    no strict 'refs';
    *{"OTRS::OPM::Installer::Logger::$level"} = sub {
        shift->print( $level, @_ );
    };
}

sub print {
    my ($self, $tag, %attr) = @_;

    my $attrs   = join " ", map{ sprintf '%s="%s"', $_, $attr{$_} }sort keys %attr;
    my $message = sprintf "<%s %s />", $tag, $attrs;
    $message >> io $self->log;
}

sub BUILD {
    my ($self) = @_;

    '<?xml version="1.0" encoding="utf-8" ?>' .
    "\n" .
    '<log>'
        > io $self->log
}
    

sub DEMOLISH {
    my ($self) = @_;

    '</log>' >> io $self->log; 
}

1;
