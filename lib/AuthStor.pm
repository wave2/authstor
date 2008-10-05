package AuthStor;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Use the Log4perl Catalyst component
use Catalyst::Log::Log4perl;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    StackTrace
    
    Authentication
    Authorization::Roles
    
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    /;

our $VERSION = '0.01';

# Configure the application. 
#
# Note that settings in authstor.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'AuthStor' );

# Create a Log4perl object
__PACKAGE__->log( Catalyst::Log::Log4perl->new(
    __PACKAGE__->path_to('Log4perl.conf')->stringify ) );

# Start the application
__PACKAGE__->setup;


=head1 NAME

AuthStor - Catalyst based application

=head1 SYNOPSIS

    script/authstor_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<AuthStor::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
