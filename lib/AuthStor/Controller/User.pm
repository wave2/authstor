package AuthStor::Controller::User;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::FormValidator;

=head1 NAME

AuthStor::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('/dashboard'));
}

sub user : Regex('^user(\d+)$') {
    my ( $self, $c ) = @_;

    my $user_id  = $c->request->snippets->[0];
    $c->stash->{user_view} = $c->model('AuthStorDB::User')->search({user_id => $user_id})->next;
    $c->stash->{title} = 'User &rsaquo '.$c->stash->{user_view}->first_name.' '.$c->stash->{user_view}->last_name;
    $c->stash->{template} = 'viewUser.tt2';
    $c->forward('AuthStor::View::TT');
}


=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
