package AuthStor::Controller::Util;

use strict;
use warnings;
use base 'Catalyst::Controller';
use String::Random;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

AuthStor::Controller::Util - Util Controller for AuthStor

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 auto

=cut

sub default : Private {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('/dashboard'));
}

sub randpasswd : Regex('^util/randpasswd$') {
    my ( $self, $c ) = @_;

    my $randpass = new String::Random; 
    $randpass->{'!'} = [ '!','@','#','$','%','^','&','*','?','_','~' ];
    $c->stash->{randpasswd} = $randpass->randpattern("!CCncc!cCn");
    $c->forward('AuthStor::View::JSON');
}


=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Alan Snelson

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
