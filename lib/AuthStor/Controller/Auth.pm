package AuthStor::Controller::Auth;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Crypt::GPG;
use Data::FormValidator;
use Digest::MD5;
use File::MimeInfo::Magic;
use IO::Scalar;

=head1 NAME

AuthStor::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub getParents($$) {
  my ($c,$currentParent) = @_;
  my @parents;
  push(@parents, $currentParent);
  while ($currentParent != 0){
    $currentParent = $c->model('AuthStorDB::AuthGroup')->search({ group_id => $currentParent })->next
->parent_id;
    push(@parents, $currentParent);
  }
  return \@parents;
}

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('/dashboard'));
}

sub auth : Regex('^auth(\d+)$') {
    my ( $self, $c ) = @_;

    my $auth_id  = $c->request->snippets->[0];

    $c->stash->{auth_view} = $c->model('AuthStorDB::Auth')->search({auth_id => $auth_id})->next();

    my $group =  $c->model('AuthStorDB::AuthGroup')->single({ group_id => $c->stash->{auth_view}->group_id });

    $ENV{'GNUPGHOME'} = $c->config->{gpgkeydir};
    my $gpg = new Crypt::GPG;
    $gpg->secretkey($c->config->{gpgkeyid});
    $gpg->passphrase($c->config->{gpgkeypass});
    my ($plaintext, $signature) = $gpg->verify($c->stash->{auth_view}->get_column('password'));
    $c->stash->{auth_pass} = $plaintext;

    #Get tags
    my $authtags = $c->model('AuthStorDB::AuthTag')->search({ auth_id => $auth_id },
    {
      join => 'tag',
      select => [ 'tag.tag_text' ],
      as => [qw/tag_text/]
    });
    while( my $tag=$authtags->next() ) {
      $c->stash->{authtags} .= $tag->get_column('tag_text').' ';
    }

    # Tag Cloud
    my $cloud = HTML::TagCloud->new(levels=>5);
    my $tags = $c->model('AuthStorDB::AuthTag')->search({ auth_id => $auth_id },
    {
      join => 'tag',
      select => [ { count => '*' }, 'tag.tag_text' ],
      as => [qw/tagcount tag_text/],
      group_by => [qw/tag_text/]
    });
    while( my $tag=$tags->next() ) {
      $cloud->add(lc($tag->get_column('tag_text')),$c->uri_for('/tag', lc($tag->get_column('tag_text'))), $tag->get_column('tagcount'));
    }
    $c->stash->{tag_cloud} =  $cloud->html(50);

    #Treeview Root Nodes
    $c->stash->{parents} = getParents($c, $group->parent_id);
    $c->stash->{group} = $group;

    #Attachments
    $c->stash->{attachments} = $c->model('AuthStorDB::AuthAtt')->search({ auth_id => $auth_id },
    {
      join => 'attachment',
      select => [ 'attachment.att_id', 'attachment.filename' ],
      as => [qw/att_id filename/],
    });

    $c->stash->{title} = 'Auth &rsaquo; '.$c->stash->{auth_view}->name;
    $c->stash->{template} = 'viewAuth.tt2';
    $c->forward('AuthStor::View::TT');
}

sub delete : Regex('^auth(\d+)/delete$') {
    my ( $self, $c ) = @_;

    my $auth_id  = $c->request->snippets->[0];
    my $auth = $c->model('AuthStorDB::Auth')->search({auth_id => $auth_id})->next();
    $auth->update({ status => 0 });

    $c->response->redirect($c->uri_for('/dashboard'));
}

sub att : Regex('^auth(\d+)/att(\d+)$') {
    my ( $self, $c ) = @_;

    my $auth_id  = $c->request->snippets->[0];
    my $att_id  = $c->request->snippets->[1];
    my $attachment = $c->model('AuthStorDB::Attachment')->single({ att_id => $c->request->snippets->[1] })->filename;
    my $filename = $c->config->{attachments}."/$auth_id/$att_id";
    $ENV{'GNUPGHOME'} = $c->config->{gpgkeydir};
    my $gpg = new Crypt::GPG;
    #$gpg->debug(1);
    $gpg->secretkey($c->config->{gpgkeyid});
    $gpg->passphrase($c->config->{gpgkeypass});
    open(ATT, $filename) or die "Can't open Attachment: $!\n";
    my $contents = do { local $/;  <ATT> };
    close(ATT);
    my ($plaintext, $signature) = $gpg->verify($contents);
    my $io_scalar = new IO::Scalar \$plaintext;
    my $mimetype = mimetype( $io_scalar );
    $c->response->headers->content_type($mimetype);
    $c->response->header('Content-Disposition' => "attachment; filename=$attachment");
    $c->response->body($plaintext);
}

sub edit : Regex('^auth(\d+)/edit$') {
    my ( $self, $c ) = @_;

    #Set-up for GPG
    $ENV{'GNUPGHOME'} = $c->config->{gpgkeydir}; 
    my $gpg = new Crypt::GPG;
    $gpg->secretkey($c->config->{gpgkeyid});
    $gpg->passphrase($c->config->{gpgkeypass});


    my $auth_id  = $c->request->snippets->[0];

    #Form submission?
    if ( $c->request->parameters->{form_submit} ) {
      my $dfv_profile =
      {
        field_filters => { 
         tags => [qw/trim strip/],
        },
        optional => [ qw( tags )],
        required => [ qw( name ) ],
      };
      my $results = Data::FormValidator->check($c->req->parameters, $dfv_profile);
      if ($results->has_invalid or $results->has_missing) {
        # do something with $results->invalid, $results->missing
        $c->stash->{errormsg} = $results->msgs;
     }
     else {
        my @authtags = ();
        my $tags = $c->model('AuthStorDB::AuthTag')->search({ auth_id => $auth_id },
        {
          join => 'tag',
          select => [qw/tag.tag_text tag.tag_id/ ],
          as => [qw/tag_text tag_id/]
        });
        #Check if tag is already assigned - if not delete it
        while( my $tag=$tags->next() ) {
          if (exists {map { $_ => 1 } split('\s+',lc($results->valid('tags')))}->{lc($tag->get_column('tag_text'))}){
            push(@authtags, lc($tag->get_column('tag_text')));
          }else{
            $c->model('AuthStorDB::AuthTag')->search({ auth_id => $auth_id, tag_id => $tag->tag_id })->delete;
            if ($c->model('AuthStorDB::AuthTag')->search({ tag_id => $tag->tag_id })->count == 0){
              $c->model('AuthStorDB::Tag')->search({ tag_id => $tag->tag_id })->delete;
            }
          }
        }

        #Add new tags
        foreach my $formtag (split('\s+',$results->valid('tags'))){
          if (!exists {map { $_ => 1 } @authtags}->{lc($formtag)}){
            my $newtag = $c->model('AuthStorDB::Tag')->find_or_create({ tag_text => $formtag });
            my $note = $c->model('AuthStorDB::AuthTag')->create({ auth_id => $auth_id, tag_id => $newtag->tag_id });
          }
        }
      }

      my $encryptedtext = $gpg->encrypt($c->request->parameters->{password}, $c->config->{gpgkeyemail});
      
      #Update the Auth
      my $auth = $c->model('AuthStorDB::Auth')->find($auth_id)->update( { name => $c->request->parameters->{name}, uri => $c->request->parameters->{uri}, username => $c->request->parameters->{username}, password => $encryptedtext, group_id => $c->request->parameters->{group_id}, notes => $c->request->parameters->{notes} });


      #New file?
      if ( my $upload = $c->request->upload('new_att') ) {
        
            my $filename = $upload->filename;
            my $file = $upload->slurp;
            my $filemd5 = Digest::MD5->new->add($file)->hexdigest;

            #Add attachment to DB
            my $attach = $c->model('AuthStorDB::Attachment')->create({
                filename  => $filename,
                md5sum => $filemd5
            });
            $attach->add_to_auth_atts({auth_id => $auth_id});

            my $directory = $c->config->{attachments}."/$auth_id";
            mkdir($directory, 0777);
            my $att_id = $attach->att_id;
            my $target = "$directory/$att_id";

            my $encrypted = $gpg->encrypt ($file, $c->config->{gpgkeyemail});
            open (ATTACH, ">$target");
            print ATTACH $encrypted;
            close (ATTACH);
    
            #unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
            #    die( "Failed to copy '$filename' to '$target': $!" );
            #}
        
        }
        #Audit Message
        $c->log->error(1,0,'Auth Updated', $c->request->address);

    }

    $c->stash->{auth_view} = $c->model('AuthStorDB::Auth')->search({auth_id => $auth_id})->next;
    my ($plaintext, $signature) = $gpg->verify($c->stash->{auth_view}->get_column('password'
));
    $c->stash->{auth_pass} = $plaintext;


    #Treeview Root Nodes
    $c->stash->{expandGroup} = $c->stash->{auth_view}->group_id;
    $c->stash->{group} = $c->model('AuthStorDB::AuthGroup')->single({ group_id => $c->stash->{auth_view}->group_id });
    $c->stash->{groups} = $c->model('AuthStorDB::AuthGroup');

    #Get tags
    my $authtags = $c->model('AuthStorDB::AuthTag')->search({ auth_id => $auth_id },
    {
      join => 'tag',
      select => [ 'tag.tag_text' ],
      as => [qw/tag_text/]
    });
    while( my $tag=$authtags->next() ) {
      $c->stash->{authtags} .= $tag->get_column('tag_text').' ';
    }

    # Tag Cloud
    my $cloud = HTML::TagCloud->new(levels=>5);
    my $tags = $c->model('AuthStorDB::AuthTag')->search({},
    {
      join => 'tag',
      select => [ { count => '*' }, 'tag.tag_text' ],
      as => [qw/tagcount tag_text/],
      group_by => [qw/tag_text/]
    });
    while( my $tag=$tags->next() ) {
      $cloud->add(lc($tag->get_column('tag_text')),"javascript:addTag('".$tag->get_column('tag_text')."',document.forms['editAuthForm'].tags)", $tag->get_column('tagcount'));
    }
    $c->stash->{tag_cloud} =  $cloud->html(50);

    #Attachments
    $c->stash->{attachments} = $c->model('AuthStorDB::AuthAtt')->search({ auth_id => $auth_id },
    {
      join => 'attachment',
      select => [ 'attachment.filename' ],
      as => [qw/filename/],
    });
 
    $c->stash->{title} = 'Auth &rsaquo; '.$c->stash->{auth_view}->name.' &rsaquo; Edit';
    $c->stash->{post_uri} = '/auth' . $auth_id . '/edit';
    $c->stash->{template} = 'editAuth.tt2';
    $c->forward('AuthStor::View::TT');
}

sub add : Local {
    my ( $self, $c ) = @_;

    my $group_id =  $c->request->param('group_id');
    my $group = $c->model('AuthStorDB::AuthGroup')->single({ group_id => $group_id });

    #Set-up for GPG
    $ENV{'GNUPGHOME'} = $c->config->{gpgkeydir};
    my $gpg = new Crypt::GPG;
    $gpg->secretkey($c->config->{gpgkeyid});
    $gpg->passphrase($c->config->{gpgkeypass});

    #Form submission?
    if ( $c->request->parameters->{form_submit} ) {
      my $dfv_profile =
      {
        field_filters => {
         tags => [qw/trim strip/],
        },
        optional => [qw( tags ) ],
        required => [ qw( name ) ],
      };
      my $results = Data::FormValidator->check($c->req->parameters, $dfv_profile);
      if ($results->has_invalid or $results->has_missing) {
        # do something with $results->invalid, $results->missing
        $c->stash->{errormsg} = $results->msgs;
      } else {

       my $encryptedtext = $gpg->encrypt($c->request->parameters->{password}, $c->config->{gpgkeyemail});

       #Add the Auth
       my $auth = $c->model('AuthStorDB::Auth')->create( { name => $c->request->parameters->{name}, uri => $c->request->parameters->{uri}, username => $c->request->parameters->{username}, password => $encryptedtext, group_id => $c->request->parameters->{group_id}, notes => $c->request->parameters->{notes} });

       #Add new tags
       foreach my $formtag (split('\s+',$results->valid('tags'))){
         my $newtag = $c->model('AuthStorDB::Tag')->find_or_create({ tag_text => $formtag });
         my $note = $c->model('AuthStorDB::AuthTag')->create({ auth_id => $auth->auth_id, tag_id => $newtag->tag_id });
       }
      }
    }

  #Treeview Root Nodes
  if ($group){
    $c->stash->{parents} = getParents($c, $group->parent_id);
    $c->stash->{group} = $group;
  }
    $c->stash->{groups} = $c->model('AuthStorDB::AuthGroup');

    $c->stash->{title} = 'Auth &rsaquo; Add';
    $c->stash->{post_uri} = '/auth/add';
    $c->stash->{template} = 'addAuth.tt2';
    $c->forward('AuthStor::View::TT');
}


###########################################
################Update Server##############
###########################################

sub updateserver : Regex('^auth(\d+)/updateserver$') {
    my ( $self, $c ) = @_;

#Retrieve all Auth info and stash for use
    my $auth_id  = $c->request->snippets->[0];
    $c->stash->{auth_view} = $c->model('AuthStorDB::Auth')->search({auth_id => $auth_id})->next();

    my $group =  $c->model('AuthStorDB::AuthGroup')->single({ group_id => $c->stash->{auth_view}->group_id });

#Set-up for GPG
    $ENV{'GNUPGHOME'} = $c->config->{gpgkeydir};
    my $gpg = new Crypt::GPG;
    $gpg->secretkey($c->config->{gpgkeyid});
    $gpg->passphrase($c->config->{gpgkeypass});

#Unencrypt Auth password
    my ($plaintext, $signature) = $gpg->verify($c->stash->{auth_view}->get_column('password'));
    $c->stash->{auth_pass} = $plaintext;






    # Tag Cloud
    my $cloud = HTML::TagCloud->new(levels=>5);
    my $tags = $c->model('AuthStorDB::AuthTag')->search({},
    {
      join => 'tag',
      select => [ { count => '*' }, 'tag.tag_text' ],
      as => [qw/tagcount tag_text/],
      group_by => [qw/tag_text/]
    });
    while( my $tag=$tags->next() ) {
      $cloud->add(lc($tag->get_column('tag_text')),$c->uri_for('/search/tag', lc($tag->get_column('tag_text'))), $tag->get_column('tagcount'));
    }
    $c->stash->{tag_cloud} =  $cloud->html(50);
    $c->stash->{title} = 'Update Server';
    $c->stash->{template} = 'updateServer.tt2';
    $c->forward('AuthStor::View::TT');
}


=head1 Author

Charlie &
Raul S Lasluisa

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
