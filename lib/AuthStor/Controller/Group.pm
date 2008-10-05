package AuthStor::Controller::Group;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::FormValidator;

=head1 NAME

AuthStor::Controller::Group - Catalyst Controller

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

sub group : Regex('^group(\d+)$') {
    my ( $self, $c ) = @_;

    my $group_id  = $c->request->snippets->[0];
    $c->stash->{group_view} = $c->model('AuthStorDB::Group')->single({group_id => $group_id});

    #Treeview Root Nodes
    $c->stash->{expandGroup} = $c->stash->{group_view}->parent_id;
    $c->stash->{group} = $c->model('AuthStorDB::Group')->single({ group_id => $group_id });

    $c->stash->{title} = 'Group &rsaquo; '.$c->stash->{group_view}->name;
    $c->stash->{template} = 'viewGroup.tt2';
    $c->forward('AuthStor::View::TT');
}

sub add : Local {
    my ( $self, $c ) = @_;

    my $parent_id = $c->request->param('parent_id') ? $c->request->param('parent_id') : 1;
    my $name = $c->request->param('name');
    my $description = $c->request->param('description');

    #Form submission?
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
      my $dfv_profile =
      {
        field_filters => {
         name => [qw/trim strip/],
        },
        'required' => [ qw( name ) ],
      };
      my $results = Data::FormValidator->check($c->req->params, $dfv_profile);
      if ($results->has_invalid or $results->has_missing) {
        # do something with $results->invalid, $results->missing
        $c->stash->{error_msg} = $results->msgs;
      }else{
       #Add the new Group
       my $group = $c->model('AuthStorDB::Group')->create({ parent_id => $parent_id, name => $name, description => $description });
      }
    }

    $c->stash->{expandGroup} = $parent_id;
    $c->stash->{group} = $c->model('AuthStorDB::Group')->single({ group_id => $parent_id });
    $c->stash->{groups} = $c->model('AuthStorDB::Group');
    $c->stash->{parent_id} = $parent_id;
    $c->stash->{title} = 'Group &rsaquo; Add';
    $c->stash->{template} = 'addGroup.tt2';
    $c->forward('AuthStor::View::TT');
}

sub delete : Regex('^group(\d+)/delete$') {
    my ( $self, $c ) = @_;

    my $group_id  = $c->request->snippets->[0];

    #Check for child groups
    if ($c->model('AuthStorDB::Group')->count({parent_id => $group_id})) {
      #found child groups
      $c->stash->{error_msg} = $c->model('AuthStorDB::Group')->count({parent_id => $group_id}).'group';
    }else{
      #No child groups.  Check for Auths
      if ($c->model('AuthStorDB::Auth')->count({group_id => $group_id})) {
        #Auths found in group
        $c->stash->{error_msg} = $c->model('AuthStorDB::Auth')->count({group_id => $group_id}).'auth';
      }else{
        #No Auths - lets delete this group
        $c->model('AuthStorDB::Group')->find({group_id => $group_id})->delete;
        $c->response->redirect($c->request->headers->referer);
        return 1;
      }
    } 

    $c->stash->{group_view} = $c->model('AuthStorDB::Group')->single({group_id => $group_id});

    $c->stash->{expandGroup} = $group_id;
    $c->stash->{group} = $c->model('AuthStorDB::Group')->single({ group_id => $group_id });
    $c->stash->{groups} = $c->model('AuthStorDB::Group');
    $c->stash->{title} = 'Group &rsaquo; '.$c->stash->{group_view}->name.' &rsaquo; Edit';
    $c->stash->{template} = 'editGroup.tt2';
    $c->forward('AuthStor::View::TT');
    
}

sub edit : Regex('^group(\d+)/edit$') {
    my ( $self, $c ) = @_;

    my $group_id  = $c->request->snippets->[0];

    $c->stash->{group_view} = $c->model('AuthStorDB::Group')->single({group_id => $group_id});

    $c->stash->{expandGroup} = $group_id;
    $c->stash->{group} = $c->model('AuthStorDB::Group')->single({ group_id => $group_id });
    $c->stash->{groups} = $c->model('AuthStorDB::Group');
    $c->stash->{title} = 'Group &rsaquo; '.$c->stash->{group_view}->name.' &rsaquo; Edit';
    $c->stash->{template} = 'editGroup.tt2';
    $c->forward('AuthStor::View::TT');
}

sub children : Regex('^children(\d+)$') {
    my ( $self, $c ) = @_;
    my $group_id  = $c->request->snippets->[0];
    #$c->stash->{message} = $c->model('AuthStorDB::Group')->search({parent_id => $group_id})->next->name;
    my @groups;
    my $rs = $c->model('AuthStorDB::Group')->search({parent_id => $group_id});
    while(my $group = $rs->next){
      push(@groups,[$group->name,$group->group_id]);
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


=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
