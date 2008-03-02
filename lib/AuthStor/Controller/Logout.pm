package AuthStor::Controller::Logout;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::Logout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    # Clear the user's state
    $c->logout;
    
    # Send the user to the starting point
    $c->response->redirect($c->uri_for('/'));
}


=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
