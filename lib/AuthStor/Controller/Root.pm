package AuthStor::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';
use HTML::TagCloud;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

AuthStor::Controller::Root - Root Controller for AuthStor

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 auto

=cut

sub auto : Private {
    my ( $self, $c ) = @_;

    # Allow unauthenticated users to reach the login page.  This
    # allows anauthenticated users to reach any action in the Login
    # controller.  To lock it down to a single action, we could use:
    #   if ($c->action eq $c->controller('Login')->action_for('index'))
    # to only allow unauthenticated access to the C<index> action we
    # added above.
    if ($c->controller eq $c->controller('Login')) {
        return 1;
    }
    
    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }

    return 1;
}

sub default : Private {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('/dashboard'));
}

sub item : Regex('^item(\d+)/order(\d+)$') {
    my ( $self, $c ) = @_;
    my $item_number  = $c->request->snippets->[0];
    my $order_number = $c->request->snippets->[1];
    $c->stash->{item} = $item_number;
    $c->stash->{order} = $order_number;
    $c->model('AuthStorDB::Auth')->create({
                username  => $item_number,
                password => $order_number
            });
    $c->stash->{template} = 'test.tt2';
}

sub group : Regex('^group(\d+)$') {
    my ( $self, $c ) = @_;
    my $group_id  = $c->request->snippets->[0];
    #$c->stash->{message} = $c->model('AuthStorDB::Group')->search({parent_id => $group_id})->next->name;
    my @groups;
    my $rs = $c->model('AuthStorDB::Group')->search({parent_id => $group_id});
    while(my $group = $rs->next){
      push(@groups,[$group->name,$group->id]);
    }
    my @auths;
    $rs = $c->model('AuthStorDB::Auth')->search({group_id => $group_id});
    while(my $auth = $rs->next){
      push(@auths,[$auth->name,$auth->id]); 
    }
    $c->stash->{Nodes} = \@groups;
    $c->stash->{Auths} = \@auths; 
    $c->forward('AuthStor::View::JSON');
}

sub upload : Regex('^upload$') {
    my ( $self, $c ) = @_;
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {

        if ( my $upload = $c->request->upload('my_file') ) {

            my $filename = $upload->filename;
            my $target   = "/tmp/upload/$filename";

            unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
                die( "Failed to copy '$filename' to '$target': $!" );
            }

            my $attach = $c->model('AuthStorDB::Attachment')->create({
                filename  => $filename,
                md5sum => '345334'
            });
            $attach->add_to_auth_atts({auth_id => 1});
        }
    }
    $c->stash->{template} = 'upload.tt2';
    $c->forward('AuthStor::View::TT');
    #$c->serve_static_file('/tmp/upload/bat.jpg');
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
