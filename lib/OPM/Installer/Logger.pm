package OPM::Installer::Logger;

# ABSTRACT: A simple logger for OPM::Installer

use strict;
use warnings;

# VERSION

use Moo;
use IO::All;
use File::Temp;
use Time::Piece;

my $file = File::Temp->new->filename;

has log  => ( is => 'ro', lazy => 1, default => sub { $file } );

for my $level (qw/notice info debug warn error/) {
    no strict 'refs'; ## no critic (ProhibitNoStrict)
    *{"OPM::Installer::Logger::$level"} = sub {
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

=for Pod::Coverage

=over 4

=item * BUILD

=back

=head1 SYNOPSIS

    use OPM::Installer::Logger;
    
    my $logger = OPM::Installer::Logger->new; # creates a new temporary file
    
    # or
    my $logger = OPM::Installer::Logger->new(
        path => 'my_installer.log',
    );

    $logger->debug( message => 'message' );
    $logger->error( type => 'cpan', message => 'Cannot install module' );
    $logger->notice( message => 'test' );
    $logger->info( any_key => 'a value' );
    $logger->warn( module => 'test', text => 'a warning' );

=head1 ATTRIBUTES

=over 4

=item * log

=back

=head1 METHODS

=head2 debug

=head2 info

=head2 warn

=head2 error

=head2 notice

=head2 print

