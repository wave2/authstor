package AuthStor::Controller::Login;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{log} || "";
    my $password = $c->request->params->{pwd} || "";
    
    # If the username and password values were found in form
    if ($username && $password) {
        # Attempt to log the user in
        if ($c->authenticate( { username => $username, password => $password } ) ) {
            # If successful, then let them use the application
            #$c->forward($c->view('Dashboard'));
		if ($c->user->get('active'))
                {
			$c->stash->{error_msg} = "This is not an acitve user";
		}
                else
                {
            		$c->response->redirect($c->uri_for('/dashboard'));
		}
            #return;
        } else {
            # Set an error message
            $c->stash->{error_msg} = "Bad username or password";
            $c->log->error(1,0,"Bad username or password", $c->request->address);
        }
    }
    
    # If either of above don't work out, send to the login page
    $c->stash->{title} = 'Login';
    $c->stash->{template} = 'login.tt2';
    $c->forward('AuthStor::View::TT');
}


=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
