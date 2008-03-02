package AuthStor::Controller::Search;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    my $query = $c->request->params->{query} || "";
    $c->stash->{search_results} = $c->model('AuthStorDB::Auth')->search({name => { 'like', "%$query%" }});
    $c->stash->{groups} = [$c->model('AuthStorDB::Group')->search({ parent_id => 0 })];
    $c->stash->{search_title} = 'Search Results for ' . $query;
    $c->stash->{template} = 'searchResults.tt2';
    $c->forward('AuthStor::View::TT');
}

sub tag : LocalRegex('^tag$') {
    my ( $self, $c, $tag_text ) = @_;

    $c->stash->{search_results} = $c->model('AuthStorDB::Auth')->search({tag_text => $tag_text},
    { join => {'map_auth_tag'=>'tag'} });
    $c->stash->{groups} = [$c->model('AuthStorDB::Group')->search({ parent_id => 0 })];
    $c->stash->{search_title} = 'Auths tagged with ' . $tag_text;
    $c->stash->{template} = 'searchResults.tt2';
    $c->forward('AuthStor::View::TT');
}

=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
