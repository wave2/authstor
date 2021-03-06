package AuthStor::Controller::User;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::FormValidator;
use Crypt::SaltedHash;

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

sub add : Local {
    my ( $self, $c ) = @_;

    my $username = $c->request->param('username');
    my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');
    $csh->add($c->request->param('password'));
    my $password = $csh->generate();
    my $email_address = $c->request->param('emailaddress');
    my $first_name = $c->request->param('firstname');
    my $last_name = $c->request->param('lastname');
    my $active = $c->request->param('active');
    my $mobile = $c->request->param('mobile');
    my $description = $c->request->param('description');
	if($active eq "on")
        {
                $active=0;
        }
        else
        {
                $active=1;
        }
    #Form submission?
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
      my $dfv_profile =
      {
        field_filters => {
         name => [qw/trim strip/],
        },
        'required' => [ qw( username password ) ],
      };
      my $results = Data::FormValidator->check($c->req->params, $dfv_profile);
      if ($results->has_invalid or $results->has_missing) {
        # do something with $results->invalid, $results->missing
        $c->stash->{error_msg} = $results->msgs;
      }else{
       #Add the new User
       my $user = $c->model('AuthStorDB::User')->create({ username => $username, password => $password, email_address => $email_address, first_name => $first_name, last_name => $last_name, active => $active, mobile => $mobile, description => $description });
      }
    }

    $c->stash->{title} = 'User &rsaquo; Add';
    $c->stash->{template} = 'addUser.tt2';
    $c->forward('AuthStor::View::TT');
}


sub user : Regex('^user(\d+)$') {
    my ( $self, $c ) = @_;

    my $user_id  = $c->request->snippets->[0];
    $c->stash->{user_view} = $c->model('AuthStorDB::User')->search({user_id => $user_id})->next;
  
    #Set-Up TreeView
    $c->stash->{expandGroup} = 1;
    $c->stash->{group} = $c->model('AuthStorDB::AuthGroup')->single({ parent_id => 0 });

    $c->stash->{title} = 'User &rsaquo '.$c->stash->{user_view}->first_name.' '.$c->stash->{user_view}->last_name;
    $c->stash->{template} = 'viewUser.tt2';
    $c->forward('AuthStor::View::TT');
}

sub editUser : Regex('^user(\d+)/edit$') {
    my ( $self, $c ) = @_;

    my $user_id  = $c->request->snippets->[0];
    $c->stash->{user_view} = $c->model('AuthStorDB::User')->search({user_id => $user_id})->next;

    #Form submission?
    if ( defined($c->request->parameters->{form_submit}) ) {
      #Check if this includes password reset - if it does we require all 3 fields (current, new and confirm)
      my $dfv_profile ;
      if ($c->request->parameters->{currentpass} || $c->request->parameters->{newpass} || $c->request->parameters->{confirmpass}){
        $dfv_profile =
        {
          field_filters => {
          tags => [qw/trim strip/],
          },
          optional => [ qw( firstname lastname)],
          required => [ qw( currentpass newpass confirmpass username ) ],
        };
      }else{ 
        $dfv_profile =
        {
          field_filters => {
          tags => [qw/trim strip/],
          },
          optional => [ qw( firstname lastname)],
          required => [ qw( username ) ],
        };
      }
      my $results = Data::FormValidator->check($c->req->parameters, $dfv_profile);
      if ($results->has_invalid or $results->has_missing) {

        # do something with $results->invalid, $results->missing
        $c->stash->{invalidform} = $results->msgs;

      }else{

        #Password Update?
        if ($c->request->parameters->{currentpass}){

         if ($c->request->parameters->{newpass} eq $c->request->parameters->{confirmpass}){

          my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');

          #Did the user enter the correct current password?
          if ($csh->validate($c->stash->{user_view}->password,$c->request->parameters->{currentpass})){ 

            #Hash old password
            my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');
            $csh->add($c->request->param('newpass'));
            my $password = $csh->generate();

            #Update the User
            my $userpass = $c->model('AuthStorDB::User')->find($user_id)->update( { username => $c->request->parameters->{username}, first_name => $c->request->parameters->{firstname}, last_name => $c->request->parameters->{lastname}, password => $password });

            $c->stash->{usererr} = 'User updated successfully';
            $c->stash->{passworderr} = 'Password updated successfully';

          }else{
            $c->stash->{passworderr} = 'Please enter valid current password.';
          }
          }else{
            $c->stash->{passworderr} = 'Passwords do not match';
          }

        } else {
          my $user = $c->model('AuthStorDB::User')->find($user_id)->update( { username => $c->request->parameters->{username}, first_name => $c->request->parameters->{firstname}, last_name => $c->request->parameters->{lastname} });
          $c->stash->{usererr} = 'User updated successfully';
        }
      }
    }

    #Get current user details
    $c->stash->{user_view} = $c->model('AuthStorDB::User')->search({user_id => $user_id})->next;

    #Set-Up TreeView
    $c->stash->{expandGroup} = 1;
    $c->stash->{group} = $c->model('AuthStorDB::AuthGroup')->single({ parent_id => 0 });

    $c->stash->{title} = 'User &rsaquo '.$c->stash->{user_view}->first_name.' '.$c->stash->{user_view}->last_name.' &rsaquo edit';
    $c->stash->{template} = 'editUser.tt2';
    $c->forward('AuthStor::View::TT');
}


sub info : Regex('^user/info$') {
        my ( $self, $c ) = @_;
        my $json = JSON->new->utf8->space_after->encode({a => [1,2]});
        my @users;
        my $rs = $c->model('AuthStorDB::User')->search({active => 0});
        while(my $user = $rs->next){
                push(@users,[$user->user_id,$user->first_name,$user->last_name]);
        }
        $c->stash->{Users} = \@users;
        $c->forward('AuthStor::View::JSON');
}


=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
