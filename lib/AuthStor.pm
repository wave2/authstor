package AuthStor;

use Moose;
use namespace::autoclean;

use Catalyst::Runtime '5.80';

# Use the Log4perl Catalyst component
use Catalyst::Log::Log4perl;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    
    Authentication
    Authorization::Roles
    
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    /;
extends 'Catalyst';

our $VERSION = '1.0';

__PACKAGE__->config( name => 'AuthStor' );

# Start the application
__PACKAGE__->setup;

# Create a Log4perl object
__PACKAGE__->log( Catalyst::Log::Log4perl->new(
    __PACKAGE__->path_to('Log4perl.conf')->stringify ) );

=head1 NAME

AuthStor - Web Based Password Management

=head1 SYNOPSIS

    script/authstor_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<AuthStor::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Alan Snelson

=head1 LICENSE

See the file LICENSE for details.

=cut

1;
